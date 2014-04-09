describe Telesms::Base do
  let(:klass) { Telesms::Base }

  describe ".gateways" do
    subject { klass.gateways }

    it { should be_a Hash }
    it { should include({ 'Verizon' => { sms: 'vtext.com', mms: 'vswpix.com' }}) }
  end
end