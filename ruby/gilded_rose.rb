class GildedRose
  attr_accessor :items

  def initialize(items)
    @items = items
  end

  def update_quality()
    items.each do |item|
      item_spec = ItemSpecification.build(item)
      item_spec.update_quality
      item_spec.update_sell_in
    end
  end
end

class ItemSpecification
  attr_accessor :item, :max_quality, :min_quality

  def self.build(item)
    case item.name
    when /\bAged Brie\b/
      AgedBrie.new(item)
    when /\bSulfuras\b/
      Sulfuras.new(item)
    when /\bBackstage\b/
      BackstagePass.new(item)
    else
      self.new(item)
    end
  end

  def initialize(item)
    @item = item
    @max_quality = 50
    @min_quality = 0
  end

  def update_quality
    return if item.quality == min_quality

    if item.sell_in >= 0
      item.quality -= 1
    else
      item.quality -= 2
    end

    item.quality = min_quality if item.quality < min_quality
  end

  def update_sell_in
    item.sell_in -= 1
  end
end

class AgedBrie < ItemSpecification
  def update_quality
    return if item.quality == max_quality

    item.quality += 1
  end

  def update_sell_in
    item.sell_in -= 1
  end
end

class Sulfuras < ItemSpecification
  def update_quality
    item.quality
  end

  def update_sell_in
    item.sell_in
  end
end

class BackstagePass < ItemSpecification
  def update_quality
    item.quality = 0 and return if item.sell_in < 0

    return if item.quality == max_quality

    if item.sell_in <= 5
      item.quality += 3
    elsif item.sell_in <= 10
      item.quality += 2
    else
      item.quality += 1
    end
  end

  def update_sell_in
    item.sell_in -= 1
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
