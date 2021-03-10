#!/usr/bin/ksh
# Set up Solaris random device from patch 112438-01 without reboot
# Moderate error checking only since this should be straightforward.
#
# (c) 2002 Andrew J. Caines. Permission to modify and distribute is
# granted on condition the copyright message is included and modifications
# are clearly identified.
#
# Incoporating suggestions and changes from these SunManager list members:
# Thomas Anders <anders@hmi.de>, Dan Astoorian <djast@cs.toronto.edu>,
# Prümm Gerd <gerd.pruemm@alcatel.ch>, Adam Mazza <adam@68e.com>.
# Script rewrite for functional changes and reliability improvement based
# on contribution from from Jeff Bledsoe.

PATH=/usr/bin:/usr/sbin

Patch=${Patch:-112438}  # Just in case it ever changes

# Set up tempfile
TmpFile=/tmp/.$$.$RANDOM ; rm -f $TmpFile ; touch $TmpFile; chmod 600 $TmpFile

function bailout
{ echo "$*. Exiting" >&2 ; exit 1
}

# Check patch is installed
echo "Checking for patch $Patch...\c"
if showrev -p | egrep -s "^Patch: ${Patch}-"
then	echo " installed."
else	bailout " not installed. Install it and try again."
fi

# Activate random kernel module with workaround for module dependency problem
echo "Removing random device from name_to_major"
name_to_major=$(</etc/name_to_major)
echo "$name_to_major" | sed '/random/d' > /etc/name_to_major

# Add driver to create device nodes and load module
echo "Adding driver to system"
add_drv -m '* 0644 root sys' random || bailout "Driver random failed to add"

# Report results
echo "Finished. You now have the following random devices:"
ls -l /dev/*random /devices/pseudo/random@0:*random

# Test
echo "Do you want to test the new device? (y/n) \c"
read yn
case $yn in
     [Yy]*) echo "Running: dd if=/dev/random of=$TmpFile bs=512 count=1"
            dd if=/dev/random of=$TmpFile bs=512 count=1
	    echo "Running: strings $TmpFile"
	    echo "You should see a few lines of random garbage:"
	    ;;
     [Nn]*) echo "Your blind faith will be rewarded in the next life."
            echo "Your reward confiration code is:"
	    ;;
esac

strings $TmpFile
rm -f $TmpFile

exit 0
   
################################################################################
# The remainder of this script never runs, but is left as refernce for use
# and locations of the relvant data and commands.

# Find device major
major=$(nawk '/^random/{print $2}' /etc/name_to_major)

# Make pseudodevices for both devices
echo "Making device nodes."
mknod /devices/pseudo/random@0:random c $major 0
mknod /devices/pseudo/random@0:urandom c $major 1

mode=$(nawk '/^random/{print $2}' /etc/minor_perm)
user=$(nawk '/^random/{print $3}' /etc/minor_perm)
group=$(nawk '/^random/{print $4}' /etc/minor_perm)

chown $user:$group /devices/pseudo/random@0:*random
chmod $mode /devices/pseudo/random@0:*random

# Make dev links
echo "Making device links."
cd /dev
ln -s ../devices/pseudo/random@0:random /dev/random
ln -s ../devices/pseudo/random@0:urandom /dev/urandom

# load the module
echo "Loading driver."
modload /kernel/drv/random

# Prime the pump with half-decent data source
echo "Priming entropy pool."
alias primepool='dd if=/dev/mem bs=512 count=16 2>&- | crypt $RANDOM'
primepool > /dev/random 2>&- # Gives "/dev/random: cannot create"
primepool > /dev/random      # Runs fine
