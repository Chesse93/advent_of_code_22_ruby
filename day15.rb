def input
  @input ||= File.read('input/15.txt').split("\n")
end

# Sum of Points you have to go to get from target to source (x and y)
# this distance is important to see in which area a sensor can see beacons
def manhattan(sensor_x, sensor_y, beacon_x, beacon_y)
  (sensor_x - beacon_x).abs + (sensor_y - beacon_y).abs
end

def sensors
  @sensors ||= input.map do |line|
    sensor, beacon = line.split(':')
    sensor_x, sensor_y = sensor.scan(/\d+/).map(&:to_i)
    beacon_x, beacon_y = beacon.scan(/-?\d+/).map(&:to_i)

    [[sensor_x, sensor_y], manhattan(sensor_x, sensor_y, beacon_x, beacon_y)]
  end
end

# Should be refactored cause we iterate over the input twice
def beacons
  @beacons ||= input.map do |line|
    _, beacon = line.split(':')
    beacon_x, beacon_y = beacon.scan(/-?\d+/).map(&:to_i)

    [[beacon_x, beacon_y]]
  end
end

# Method based on https://www.youtube.com/watch?v=EWLwgLgRFjc
def determine_positions(detected_points)
  count_at2 = 0
  while detected_points.size > 1
    new_ranges = []
    detected_points.each_with_index do |r, idx|
      next if detected_points[idx + 1].nil?

      from1 = r[0]
      from2 = detected_points[idx + 1][0]
      to1 = r[1]
      to2 = detected_points[idx + 1][1]

      if to2 > from1 && from2 > from1
        new_ranges << [from1, to1]
        new_ranges.unshift([from2, to2])
        next
      end

      if from1 > from2 && from1 > to2
        new_ranges << [from1, to1]
        new_ranges.unshift([from2, to2])
        next
      end

      if to1 >= to2 && from1 >= from2
        new_ranges << [from2, to1]
        next
      end
      if from1 <= from2 && to1 >= to2
        new_ranges << [from1, to1]
        next
      end
      if from2 <= from1 && to2 >= to1
        new_ranges << [from2, to2]
        next
      end
      if to1 >= from2 && to2 > from1
        new_ranges << [from1, to2]
        next
      end
      if to1 >= to2 && from2 <= from1
        new_ranges << [from2, to1]
        next
      end
    end
    detected_points = new_ranges.uniq.shuffle
    if count_at2 > 50
      final_y = target_y
      final_x = detected_points.flatten.sort[1] + 1
      break
    end
    count_at2 += 1 if detected_points.size == 2
  end
  [final_x, final_y]
end

def get_turning_frequency(distress_beacon_max_coordinates)
  final_x = nil
  final_y = nil
  distress_beacon_max_coordinates.times do |target_y|
    # puts "#{target_y + 1}/#{distress_beacon_max_coordinates}"
    detected_points = []
    sensors.each do |(x, y), distance|
      next if (y - target_y).abs > distance

      remainder = distance - (y - target_y).abs
      from = x - remainder
      to = x + remainder
      detected_points << [from.negative? ? 0 : from,
                          to > distress_beacon_max_coordinates ? distress_beacon_max_coordinates : to]
    end

    unless final_y.nil? && final_x.nil?
      final_x, final_y = determine_positions(detected_points)
      break
    end
  end

  (final_x * 4_000_000) + final_y
end

def day_15_1(target_y)
  detected_points = []

  sensors.each do |(x, y), distance|
    # skip sensor if sensor cant see the target line
    next if (y - target_y).abs > distance

    remainder = distance - (y - target_y).abs
    # range which can be seen by the sensor on the target line
    detected_points << [x - remainder, x + remainder]
  end

  detected_points.flatten!

  detected_points.min.abs + detected_points.max.abs
end

def day_15_2(distress_beacon_max_coordinates)
  get_turning_frequency(distress_beacon_max_coordinates)
end

if __FILE__ == $0
  target_y = 2_000_000 # 10
  distress_beacon_max_coordinates = 4_000_000 # 20
  puts "In the row where y = #{target_y}, there are #{day_15_1(target_y)} positions where a beacon cannot be present."
  puts "The tuning frequency is #{day_15_2(distress_beacon_max_coordinates)}"
end
