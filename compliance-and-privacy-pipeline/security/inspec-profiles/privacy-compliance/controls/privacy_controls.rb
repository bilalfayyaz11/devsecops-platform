title 'Privacy and Data Protection Controls'

control 'privacy-001' do
  impact 0.8
  title 'Password Storage Security'
  desc 'Ensure passwords are not stored in plain text or weak hashes'
  describe file('/home/ubuntu/devsecops-lab/src/app.py') do
    its('content') { should_not match(/password.*=.*['"][^'"\$]/) }
  end
end

control 'privacy-002' do
  impact 0.9
  title 'Session Security'
  desc 'Ensure secure session management is configured'
  describe file('/home/ubuntu/devsecops-lab/src/app.py') do
    its('content') { should match(/secret_key/) }
  end
end

control 'privacy-003' do
  impact 0.7
  title 'Data Minimization'
  desc 'Ensure PII like SSNs are not collected'
  describe command('sqlite3 /home/ubuntu/devsecops-lab/src/users.db ".schema"') do
    its('stdout') { should_not match(/ssn|social_security|credit_card/) }
  end
end
