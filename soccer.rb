# soccer
require 'rspec/autorun'
class Game
  attr_accessor :result_of_game

  def initialize(result_of_game)
    @result_of_game = result_of_game
    names = @result_of_game.scan(/\b[A-Za-z ]{1,20}/)
    teams_point = @result_of_game.scan(/\d{1,2}/)
    if teams_point[0] > teams_point[1]
      Team.new(names[0], 3)
      Team.new(names[1], 0)
    elsif teams_point[0] < teams_point[1]
      Team.new(names[0], 0)
      Team.new(names[1], 3)
    elsif teams_point[0] == teams_point[1]
      Team.new(names[0], 1)
      Team.new(names[1], 1)
    end
  end

  def self.all
    ObjectSpace.each_object(self).to_a
  end
end

class Team < Game
  attr_accessor :name, :points

  def initialize(name, points)
    @name = name
    @points = points
  end

  def self.all
    ObjectSpace.each_object(self).to_a
  end
end

def parsing_file(path)
  file = File.open(path)
  contents = file.read
  array = contents.scan(/\b[A-Za-z ]{1,15}\s\d,\s\b[A-Za-z ]{1,15}\s\d/)
  array.each do |ar|
    Game.new(ar)
  end
end

  puts 'Enter file name or path: '
  path = gets.chomp
  parsing_file(path)

  # All same Teams object plus by points and output in right position
  array_of_hashes = []
  Team.all.each do |team|
    array_of_hashes << {team.name.to_s => team.points.to_i}
  end
  hash = array_of_hashes.inject{|memo, el| memo.merge( el ){|k, old_v, new_v| old_v + new_v}}
  h = hash.sort_by {|key, value| value}.reverse
  i = 0
  h.map do |k,v|
    i+=1
    if v.to_i == 1
      point_tag = 'pt'
    else
      point_tag = 'pts'
    end
    puts "#{i.to_s}.#{k} #{v} #{point_tag}"
  end



#  TESTS


describe Game, "soccer" do
  it "it returns random total within expected range" do
    game = 'Lions 3, Snakes 3'
    total = Game.new(game)
    expect(Team.all.count) == 2
    expect(Team.all.last.name) == ('Lions')
    expect(Team.all.last.points) == 1
    expect(Team.all.first.name) == ('Snakes')
    expect(Team.all.first.points) == 1
  end

  it "it returns random total within expected range" do
    path = 'teams'
    parsing_file(path)
    expect(Game.all.count) == 5
    expect(Game.all.first) == 'Lions 3, Snakes 3'
  end
end