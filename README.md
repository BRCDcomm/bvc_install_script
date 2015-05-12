# bvc_install_script

This script automates the install of BVC version 1.2.  With some changes it might work with other versions of BVC, however, it has only been tested with 1.2. This script assumes you have installed and setup Ubuntu 14.04 as per Jim Burns video here:  https://www.youtube.com/watch?v=saNnY7A55gM or you can download a bare Ubuntu 14.04 virtual box VM that I created by following Jim's instructions here: https://s3.amazonaws.com/elbrys-public/ubuntu_14_04_for_bvc.ova
The username and password are: bvc-user/bvc-user

The BVC quick start instructions recommend installing BVC in the /opt directory. This script has been tested installing in the /opt directory as per the instructions.

To use this script do the following:
- 1) copy/move this script to the /opt directory
- 2) make the script executable e.g. sudo chmod a+x /opt/install_bvc.sh
- 3) download bvc-1.2.0.zip and bvc-dependencies-1.2.0.zip from http://www.brocade.com/forms/jsp/vyatta-controller/index.jsp
- 4) copy/move bvc-1.2.0.zip and bvc-dependencies-1.2.0.zip to the /opt directory
- 5) cd to the /opt directory and run the script as follows: sudo ./install_bvc.sh
- 6) if the script runs successfully you should see BVC1.2 installed.  If not, you can always try running the steps manually as per the quick start guide from Brocade 
