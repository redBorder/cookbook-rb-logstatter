Name:     cookbook-rb-logstatter
Version:  %{__version}
Release:  %{__release}%{?dist}
BuildArch: noarch
Summary: rblogstatter cookbook to install and configure it in redborder environments


License:  GNU AGPLv3
URL:  https://github.com/redBorder/cookbook-rb-logstatter
Source0: %{name}-%{version}.tar.gz

%description
%{summary}

%prep
%setup -qn %{name}-%{version}

%build

%install
mkdir -p %{buildroot}/var/chef/cookbooks/rb-logstatter
mkdir -p %{buildroot}/usr/lib64/rb-logstatter

cp -f -r  resources/* %{buildroot}/var/chef/cookbooks/rb-logstatter/
chmod -R 0755 %{buildroot}/var/chef/cookbooks/rb-logstatter
install -D -m 0644 README.md %{buildroot}/var/chef/cookbooks/rb-logstatter/README.md

%pre

%post
case "$1" in
  1)
    # This is an initial install.
    :
  ;;
  2)
    # This is an upgrade.
    su - -s /bin/bash -c 'source /etc/profile && rvm gemset use default && env knife cookbook upload rblogstatter'
  ;;
esac

systemctl daemon-reload
%files
%attr(0755,root,root)
/var/chef/cookbooks/rb-logstatter
%defattr(0644,root,root)
/var/chef/cookbooks/rb-logstatter/README.md

%doc

%changelog
* Sun Jan 21 2024 - Miguel Álvarez <malvarez@redborder.com> - 0.0.2-1
- Add apstate pipeline
* Mon Sep 25 2023 - Miguel Álvarez <malvarez@redborder.com> - 0.0.1-1
- Initial spec version
