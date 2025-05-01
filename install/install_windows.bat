@echo off
set /p username=Enter Pi username:  
set /p ip=Enter Pi IP address:  
plink -ssh -v -pw raspberry %username%@%ip% -m setup.sh
