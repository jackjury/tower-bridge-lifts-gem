require 'spec_helper'

describe TowerBridgeLifts do
  it 'gem has a version number' do
    expect(TowerBridgeLifts::VERSION).not_to be nil
  end
end
  
describe TowerBridgeLifts::Base do
  subject(:tbl) { described_class.new }

  it 'instantiates' do
    expect(tbl).to be_instance_of(described_class)
    expect(tbl.updated).not_to be_nil
  end

  it 'has lifts if no errors' do 
    if tbl.error.nil?
      expect(tbl.lifts.map).to all(be_a(TowerBridgeLifts::Lift))
    end
  end

  it 'has one lift' do
    lift = TowerBridgeLifts::Lift.new(timestamp: Time.now, vessel: "Vessel Name", direction: :up_river)
    tbl.lifts = [lift]
    expect(tbl.lifts.count).to eq(1) 
  end

end


