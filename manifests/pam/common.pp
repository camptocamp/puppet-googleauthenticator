# @summary Common PAM requirements for googleauthenticator.
class googleauthenticator::pam::common {
  $package = $facts['os']['name'] ? {
    /Debian|Ubuntu/ => 'libpam-google-authenticator',
    /RedHat|CentOS/ => 'google-authenticator',
    default         => '',
  }

  $service = $facts['os']['name'] ? {
    /RedHat|CentOS/ => 'sshd',
    default         => 'ssh',
  }

  package { 'pam-google-authenticator':
    name => $package,
  }

  # Setup the three basic PAM modes
  googleauthenticator::pam::mode {
    'all-users':
      service => $service;

    'root-only':
      succeed_if => 'uid > 0',
      service    => $service;

    'systemwide-users':
      secret  => "/etc/google-authenticator/\${USER}/google_authenticator",
      service => $service;
  }
}
