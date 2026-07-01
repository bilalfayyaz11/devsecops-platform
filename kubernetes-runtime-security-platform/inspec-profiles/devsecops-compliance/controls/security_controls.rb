control 'system-security-1' do
  title 'System security configuration'
  desc 'Ensure system is configured with security best practices'
  impact 0.8
  describe file('/etc/passwd') do
    its('mode') { should cmp '0644' }
  end
end

control 'application-security-1' do
  title 'Application security checks'
  desc 'Ensure application follows security best practices'
  impact 0.9
  describe file('/app/package.json') do
    it { should exist }
  end
end
