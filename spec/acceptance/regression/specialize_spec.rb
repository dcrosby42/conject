require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe "object specialization" do
  subject { new_object_context }

  before do
    append_test_load_path "specialization"
    require 'finn'
    require 'jake'
    require 'batman'
    require 'robin'
    require 'clock'
    require 'team'
    require 'floor'
  end

  after do
    restore_load_path
  end


  it "lets you define an object by class and a subset of specialized components" do
    subject.configure_objects({
      adventure_time: {
        class: Team, 
        specialize: { 
          hero: "finn",
          sidekick: "jake" }},
      dark_knight: {
        class: Team,
        specialize: {
          hero: "batman",
          sidekick: "robin" }}
    })

    adventure_time = subject[:adventure_time]
    adventure_time.class.should == Team
    adventure_time.hero.should be
    adventure_time.hero.should == subject[:finn]
    adventure_time.hero.floor.should == subject[:floor]
    adventure_time.sidekick.should be
    adventure_time.sidekick.should == subject[:jake]
    adventure_time.sidekick.floor.should == subject[:floor]
    adventure_time.clock.should be
    adventure_time.clock.should == subject[:clock]

    dark_knight = subject[:dark_knight]
    dark_knight.class.should == Team
    dark_knight.hero.should be
    dark_knight.hero.should == subject[:batman]
    dark_knight.hero.floor.should == subject[:floor]
    dark_knight.sidekick.should be
    dark_knight.sidekick.should == subject[:robin]
    dark_knight.sidekick.floor.should == subject[:floor]
    dark_knight.clock.should be
    dark_knight.clock.should == subject[:clock]
  end

end

