describe Telesms::Base do
  let(:klass) { Telesms::Base }

  describe ".gateways" do
    subject { klass.gateways }

    it { should be_a Hash }
    it { should include('Verizon Wireless' => { sms: 'vtext.com', mms: 'vzwpix.com' }) }
  end
end