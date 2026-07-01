{
  persistence.directories = ["/var/log/journal"];

  services.journald.settings.Journal.MaxRetentionSec = "2week";
}
