require 'rspec'

require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  context "Default Item" do
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

    it "does not reduce item quality to be less than 0" do
      items = [Item.new("foo", 1, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to be >= 0
    end
  end

  context "Aged Brie" do
    it "increases quality" do
      items = [Item.new("Aged Brie", 1, 25)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 26
    end

    it "increases quality by 2 passed sell_in" do
      items = [Item.new("Aged Brie", 0, 2)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 4
    end

    it "does not increase quality to more than 50" do
      items = [Item.new("Aged Brie", 1, 50)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 50
    end
  end

  context "Sulfuras" do
    it "does not reduce quality" do
      items = [Item.new("Sulfuras, Hand of Ragnaros", 3, 48)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 48
    end

    it "does not change in sell_in value" do
      items = [Item.new("Sulfuras, Hand of Ragnaros", 3, 50)]
      GildedRose.new(items).update_quality()
      expect(items[0].sell_in).to eq 3
    end
  end

  context "Backstage Passes" do
    it "increases quality by 1 if sell_in is more than 10" do
      items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 13, 24)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 25
    end

    it "increases quality by 2 if sell_in is 10 or less" do
      items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 10, 22),
      Item.new("Backstage passes to a TAFKAL80ETC concert", 9, 23)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 24
      expect(items[1].quality).to eq 25
    end

    it "increases quality by 3 if sell_in is 5 or less" do
      items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 5, 22),
      Item.new("Backstage passes to a TAFKAL80ETC concert", 4, 23)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 25
      expect(items[1].quality).to eq 26
    end

    it "reduces quality to 0 if sell_in is negative" do
      items = [Item.new("Backstage passes to a TAFKAL80ETC concert", -1, 22)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 0
    end
  end

  context "Conjured" do
    it "reduces quality by 2" do
      items = [Item.new("Conjured", 10, 22)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 20
    end

    it "does not reduce quality to be less than 0" do
      items = [Item.new("Conjured", 22, 1)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 0
    end
  end
end
