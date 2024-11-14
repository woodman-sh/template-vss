# Monitoring Windows Shadow Copies (VSS) with Zabbix

### Description

This template is designed for monitoring the Volume Shadow Copy Service (VSS) on Windows servers, using Zabbix Agent and PowerShell scripts. It has been tested with Zabbix versions 5 to 7 LTS and supports monitoring of shadow copy status and creation times.
##
### Items

The template allows tracking of the following parameters:

- **Number of shadow copies** on each disk.
- **Date and time of the oldest** shadow copy.
- **Date and time of the newest** shadow copy.

### Triggers

- **[{#DISKNAME}] Shadow copies not found**: triggers if the number of shadow copies is zero.
- **[{#DISKNAME}] Last shadow copy older than 72 hours**: triggers if the newest copy is older than 3 days (depends on the first trigger).
##
### Installation

1. **Copy scripts**: Transfer the scripts from the scripts folder to the host where Zabbix Agent is installed.
2. **Configure settings**: Add UserParameter entries to the Zabbix Agent configuration file.
3. **Restart the agent**: Update the agent configuration by restarting the Zabbix Agent.
4. **Import the template**: Upload the 'Template VSS Windows' file to the Zabbix server and attach it to the desired host.

If you have any questions or suggestions for improving the template, please create an Issue on GitHub.
