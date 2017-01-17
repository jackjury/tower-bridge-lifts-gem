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

  it 'has a next_lift if there is a scheduled' do
    lift = TowerBridgeLifts::Lift.new(timestamp: tbl.time, vessel: "Vessel Name", direction: :up_river)
    tbl.lifts = [lift]
    expect(tbl.next_lift).to eq(lift)
  end

  it 'has no next_lift if scheduled lift is older than time + T_FULL_LIFT' do
    lift = TowerBridgeLifts::Lift.new(timestamp: (tbl.time - TowerBridgeLifts::Base::T_FULL_LIFT), vessel: "Vessel Name", direction: :up_river)
    tbl.lifts = [lift]
    expect(tbl.next_lift).to be_nil
  end

  it 'has no traffic during the lift' do
    lift1 = TowerBridgeLifts::Lift.new(timestamp: tbl.time, vessel: "Vessel Name", direction: :up_river)
    lift2 = TowerBridgeLifts::Lift.new(timestamp: (tbl.time - TowerBridgeLifts::Base::T_FULL_LIFT + 1) , vessel: "Vessel Name", direction: :up_river)

    tbl.lifts = [lift1]
    expect(tbl.traffic).to eq(:blocked)

    tbl.lifts = [lift2]
    expect(tbl.traffic).to eq(:blocked)

  end

end


