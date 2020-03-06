%define _source_payload w0.gzdio
%define _binary_payload w0.gzdio

Name:       ansible-role-dci-rhel-cki
Version:    0.0.1
Release:    1%{?dist}
Summary:    ansible-role-dci-rhel-cki
License:    ASL 2.0
URL:        https://github.com/redhat-cip/ansible-role-dci-rhel-cki
Source0:    ansible-role-dci-rhel-cki-%{version}.tar.gz

BuildArch:  noarch

%description
An Ansible role that is used to automate cki testing

%prep
%setup -qc


%build

%install
mkdir -p %{buildroot}%{_datadir}/dci/roles/dci-rhel-cki
chmod 755 %{buildroot}%{_datadir}/dci/roles/dci-rhel-cki

cp -r files %{buildroot}%{_datadir}/dci/roles/dci-rhel-cki
cp -r tasks %{buildroot}%{_datadir}/dci/roles/dci-rhel-cki


%files
%doc README.md
%license LICENSE
%{_datadir}/dci/roles/dci-rhel-cki


%changelog
* Wed Nov 27 2019 Bill Peck <bpeck@redhat.com> - 0.0.1-1
- Initial release
