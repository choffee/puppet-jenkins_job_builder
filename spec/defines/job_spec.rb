require 'spec_helper'

describe 'jenkins_job_builder::job', :type => :define do
  context 'supported operating systems' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "jenkins_job_builder::job define without any parameters on #{osfamily}" do
        let(:title) { 'test' }

        it { should contain_file('/tmp/jenkins-test.yaml') }

        it { should contain_file('/tmp/jenkins-test.yaml').with_content('') }

        it { should contain_exec('manage jenkins job - test').with(
          'command' => '/bin/sleep 0 && /usr/local/bin/jenkins-jobs --ignore-cache --conf /etc/jenkins_jobs/jenkins_jobs.ini update /tmp/jenkins-test.yaml',
          'refreshonly' => 'true',
          'require' => 'Service[jenkins]'
        )}
      end
    end
  end

  context 'supported operating systems - params' do
    describe 'increased delay' do
      let(:title) { 'test' }
      let(:params) {{
        'delay' => '5'
      }}

      it { should contain_exec('manage jenkins job - test').with(
        'command' => '/bin/sleep 5 && /usr/local/bin/jenkins-jobs --ignore-cache --conf /etc/jenkins_jobs/jenkins_jobs.ini update /tmp/jenkins-test.yaml'
      )}
    end

    describe 'custom config' do
      let(:title) { 'test' }
      let(:params) {{
        'config' => { 'test' => { 'name' => 'test' } }
      }}

      it { should contain_file('/tmp/jenkins-test.yaml').with_content(/name:\s+"test"/) }
    end
  end
end
