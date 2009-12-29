require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "has_ip_address" do
  describe "with default column" do
    before do
      build_model :visits do
        integer :ip_address
        has_ip_address
      end
    end

    describe "and setting and getting" do
      before do
        visit = Visit.new

        visit.ip_address = "127.0.0.1"

        @ip_address = visit.ip_address
      end

      it "should be a IPAddr" do
        @ip_address.should be_kind_of(IPAddr)
      end

      it "should return the set value when got" do
        @ip_address.should == IPAddr.new("127.0.0.1")
      end

    end
  end
  
  describe "with default column" do
    before do
      build_model :visits do
        integer :visitor_ip
        has_ip_address :visitor_ip
      end
    end

    describe "and setting and getting" do
      before do
        visit = Visit.new

        visit.visitor_ip = "192.168.0.1"

        @ip_address = visit.visitor_ip
      end

      it "should be a IPAddr" do
        @ip_address.should be_kind_of(IPAddr)
      end

      it "should return the set value when got" do
        @ip_address.should == IPAddr.new("192.168.0.1")
      end

    end
  end
end
