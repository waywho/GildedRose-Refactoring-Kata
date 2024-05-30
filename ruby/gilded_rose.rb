class GildedRose
  attr_accessor :items

  def initialize(items)
    @items = items
  end

  def update_quality()
    items.each do |item|
      updater = ItemUpdater.build(item)
      updater.update_quality(item)
      updater.update_sell_in(item)
    end
  end
end

class ItemUpdater
  MAX_QUALITY = 50
  MIN_QUALITY = 0

  def self.build(item)
    case item.name
    when /\bAged Brie\b/
      AgedBrieUpdater
    when /\bSulfuras\b/
      SulfurasUpdater
    when /\bBackstage\b/
      BackstagePassUpdater
    when /\bConjured\b/
      ConjuredUpdater
    else
      DefaultUpdater
    end
  end

  def self.update_quality(item)
    raise NotImplementedError
  end

  def self.update_sell_in(item)
    item.sell_in -= 1
  end
end

class DefaultUpdater < ItemUpdater
  def self.update_quality(item)
    return if item.quality == MIN_QUALITY

    if item.sell_in >= 0
      item.quality -= 1
    else
      item.quality -= 2
    end

    item.quality = MIN_QUALITY if item.quality < MIN_QUALITY
  end
end

class AgedBrieUpdater < ItemUpdater
  def self.update_quality(item)
    return if item.quality == MAX_QUALITY

    item.quality += 1
  end
end

class SulfurasUpdater < ItemUpdater
  def self.update_quality(item)
    item.quality
  end

  def self.update_sell_in(item)
    item.sell_in
  end
end

class BackstagePassUpdater < ItemUpdater
  def self.update_quality(item)
    item.quality = 0 and return if item.sell_in < 0

    return if item.quality == MAX_QUALITY

    if item.sell_in <= 5
      item.quality += 3
    elsif item.sell_in <= 10
      item.quality += 2
    else
      item.quality += 1
    end
  end
end

class ConjuredUpdater < ItemUpdater
  def self.update_quality(item)
    return if item.quality == MIN_QUALITY

    item.quality -= 2

    item.quality = 0 if item.quality < MIN_QUALITY
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
