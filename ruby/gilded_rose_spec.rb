require 'rspec'

require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  it "does not change the name" do
    items = [Item.new("foo", 0, 0)]
    GildedRose.new(items).update_quality()
    expect(items[0].name).to eq "foo"
  end

  # quality descreases twice as fast when sell by date is past
  it "reduces quality by 2 when sell_in is negative" do
    items = [Item.new("foo", -1, 50)]
    GildedRose.new(items).update_quality()
    expect(items[0].quality).to eq 48
  end

  it "does not reduce item quality to negative" do
    items = [Item.new("foo", 1, 0)]
    GildedRose.new(items).update_quality()
    expect(items[0].quality).to be >= 0
  end

  it "increases Aged Brie in quality" do
    items = [Item.new("Aged Brie", 1, 25)]
    GildedRose.new(items).update_quality()
    expect(items[0].quality).to eq 26
  end

  it "does not increase quality to more than 50" do
    items = [Item.new("Aged Brie", 1, 50)]
    GildedRose.new(items).update_quality()
    expect(items[0].quality).to eq 50
  end

  it "does not decrease quality of Sulfuras" do
    items = [Item.new("Sulfuras, Hand of Ragnaros", 3, 50)]
    GildedRose.new(items).update_quality()
    expect(items[0].quality).to eq 50
  end

  it "increases Backstage passes quality by 1 if sell_in is more than 10" do
    items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 12, 22)]
    GildedRose.new(items).update_quality()
    expect(items[0].quality).to eq 23
  end

  it "increases Backstage passes quality by 2 if sell_in is less than 10" do
    items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 3, 22)]
    GildedRose.new(items).update_quality()
    expect(items[0].quality).to eq 25
  end

  it "descrease Backstage passes quality to 0 if sell_in is negative" do
    items = [Item.new("Backstage passes to a TAFKAL80ETC concert", -1, 22)]
    GildedRose.new(items).update_quality()
    expect(items[0].quality).to eq 0
  end
end
