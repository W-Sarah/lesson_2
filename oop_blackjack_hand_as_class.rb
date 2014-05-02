class Card
attr_accessor :suit, :value

  def initialize(suit,value)
  @suit = suit
  @value = value
  end

  def output
    "The #{@value} of #{@suit}"
  end

  def to_s
    output
  end
end


class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    [ "D", "H", "C", "S"].each do |suit|
      ["2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace"].each do |value|
        @cards << Card.new(suit,value)
      end
    end
    @cards.shuffle!
  end

  def deal
      @cards.pop
    end
end


class Hand
  attr_accessor :hand, :deck

  def initialize
    @deck = Deck.new
    @hand = []
    @hand << @deck.deal
    @hand << @deck.deal
  end

  def add_card
    @hand << @deck.deal
  end

  def show_hand
    @hand.join(", ") do |card|
      card.to_s
    end
  end

  def hand_total
    values = {"2" => 2, "3" => 3, "4" => 4,"5" => 5,"6" => 6,"7" => 7,"8" => 8,"9" => 9,"10" => 10, "Jack" => 10,"Queen" => 10, "King" => 10, "Ace" =>  [1, 11] }
    hand_face_value = []
    total = 0
    total_1 = 0
    total_11 = 0
    
    @hand.each do |card|
      hand_face_value << card.value
    end

    if hand_face_value.include?("Ace")
      non_aces = hand_face_value.select { |value| value != "Ace"}
      aces = hand_face_value.select {|value| value == "Ace"}
      total_1 = non_aces.inject(0) {|sum, card| sum + values[card]} + aces.to_a.length
      total_11 = non_aces.inject(0) {|sum, card| sum + values[card]} + aces.to_a.length * 11
      if (total_11 <= 21) 
      total = total_11
      else 
      total = total_1
      end
    else 
      total = hand_face_value.inject(0) {|sum, card| sum + values[card]}
    end
  return total
  end

end


class Player
  attr_accessor :name, :player_hand

  def initialize
    @name = name
    @player_hand = Hand.new
  end


  def hit_or_stay
    puts "#{@name}, would you like to (h)it or (s)tay?"
    answer = gets.chomp
      while ["h","s"].include?(answer) == false
        puts "Please enter 'h' or 's'"
        answer = gets.chomp
      end
    return answer
  end


  def show_hand
    puts "#{@name}, you have the following cards:#{@player_hand.show_hand} for a total of #{@player_hand.hand_total}"
  end


  def play
    until self.hit_or_stay == 's'
      @player_hand.add_card
      @player_hand.hand_total
      self.show_hand
      break if @player_hand.hand_total > 20
    end
  end

  def result
    if @player_hand.hand_total == 21
      puts "Blackjack! Congratulations, you win this game!"
      exit
    elsif @player_hand.hand_total > 21
      puts "Sorry #{@name}, you have lost this game."
      exit
    else
      puts "The dealer is going to play now"
    end
  end
end

class Dealer
  attr_accessor :dealer_hand

  def initialize
    @dealer_hand = Hand.new
  end

  def show_hand
    puts "The dealer has the following cards: #{@dealer_hand.show_hand} for a total of #{@dealer_hand.hand_total}"
  end

  def play
    until @dealer_hand.hand_total > 17
      @dealer_hand.add_card
      @dealer_hand.hand_total
      self.show_hand
    end
  end
end




class Blackjack
  attr_accessor :player, :dealer, :deck

  def initialize
    @player = Player.new
    @dealer = Dealer.new
  end

  def menu
    puts "**** Welcome to Sarah's Casino - Blackjack Game ****"
    puts "Enter (p) to play Blackjack or (e) to exit the game"
    input = gets.chomp
    until ["p", "e"].include?(input)
      puts "Please enter 'p' to play or 'e' to exit"
      input = gets.chomp
    end
    if input == "e"
      exit
    else
      puts "Please enter your name"
      @player.name= gets.chomp
      puts
      puts "Welcome #{@player.name}, let's play Blackjack!"
      puts "----------------"
    end
    return input
  end

  def card_comparison
    if @dealer.dealer_hand.hand_total > @player.player_hand.hand_total && @dealer.dealer_hand.hand_total < 22
      puts "Sorry #{@player.name}, you have lost this game."
    else
      puts "Congratulations #{@player.name}, you win this game!"
    end
  end


  def run_game
    @player.show_hand
    @dealer.show_hand
    @player.play
    @player.result
    @dealer.play 
    self.card_comparison
  end

end

game = Blackjack.new
  game.menu
  game.run_game




