读\
1 ConfigurationManager.AppSettings\[\"StationCode\"\]\
写\
1 System.Configuration.Configuration config =\
System.Configuration.ConfigurationManager.OpenExeConfiguration(System.Configuration.Con\
figurationUserLevel.None);\
2 config.AppSettings.Settings\[\"StationCode\"\].Value =\
this.txtStationCode.Text;\
3 config.Save(ConfigurationSaveMode.Modified);
