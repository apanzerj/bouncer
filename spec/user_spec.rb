require 'spec_helper.rb'

RSpec.describe User do
  subject { described_class.new(github_id: 'foo') }

  it 'takes a github_id' do
    expect(subject.github_id).to eq('foo')
  end

  describe '#ldap' do
    it 'is a ldap_wrapper client' do
      expect(subject.ldap).to be_kind_of LdapWrapper
    end
  end

  describe '#ldap_record' do
    let(:ldap) { spy() }

    before do
      subject.instance_variable_set(:@ldap, ldap)
    end

    it 'calls LdapWrapper#find' do
      subject.ldap_record
      expect(ldap).to have_received(:find).with('foo')
    end


    context '#email' do
      let(:ldap_record) { nil }

      before do
        subject.instance_variable_set(:@ldap_record, ldap_record)
      end

      context 'when there is an ldap_record' do
        let(:ldap_record) { double(userprincipalname: ['a.b@optimizely.com' ]) }

        it 'returns the userprincipalname' do
          expect(subject.email).to eq('a.b@optimizely.com')
        end
      end

      context 'when there is no ldap_record' do
        before do
          allow(ldap).to receive(:find).with('foo').and_return(nil)
        end

        it 'returns false' do
          expect(subject.email).to eq(nil)
        end
      end
    end
  end

  describe '#github_admin?' do
    let(:admin) { double(login: 'foo') }
    let(:non_admin) { double(login: 'bar') }
    let(:result) { [] }

    before do
      allow(GithubUsers).to receive(:admins).and_return(result)
    end

    context 'when the user is not an admin' do
      let(:result) { [non_admin] }

      it 'returns false' do
        expect(subject.github_admin?).to eq(false)
      end
    end

    context 'when the user is a github admin' do
      let(:result) { [admin] }

      it 'returns true' do
        expect(subject.github_admin?).to eq(true)
      end
    end
  end
end
