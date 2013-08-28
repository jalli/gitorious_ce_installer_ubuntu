class gitorious::ruby_git_daemons {
  monit::config { "git-daemon":
    t_app_root => $gitorious::app_root,
    t_control_scripts_dir => $gitorious::control_scripts_dir,
  }
  file {"/etc/monit.d/git-daemons.monit":
    ensure => absent,
  }
  file {"/etc/monit.d/git-proxy.monit":
    ensure => absent,
  }
}
class gitorious::native_git_daemons {
  case $operatingsystem {
    "CentOS", "RedHat": {
        $package_list = ["git-daemon"]
    }
    "Ubuntu", "Debian": {
        $package_list = ["git-daemon-run"]
    }
  }
  monit::config { "git-daemons":
    pids_dir => "${gitorious::app_root}/log",
    pidfile => "${gitorious::app_root}/log/git-daemons.pid",
    repo_root => $gitorious::repository_root,
    require => Package[$package_list],
  }


  package { $package_list: ensure => installed }

  file { "/etc/monit.d/git-daemon.monit":
    ensure => absent,
  }
}
