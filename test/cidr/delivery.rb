require 'rubygems'
require 'bud'

class BestEffortDelivery < Bud

  def initialize(host, port)
    @addy = "#{host}:#{port}"
    super(host, port)
  end

  def state
    table :pipe, ['dst', 'src', 'id'], ['payload']
    table :pipe_out, ['dst', 'src', 'id'], ['payload']
    channel :pipe_chan, 0, ['dst', 'src', 'id'], ['payload']
    channel :tickler, 0, ['self']
  end
  
  declare
    def snd
      pipe_chan <+ pipe.map do |p|
        unless pipe_out.map{|m| m.id}.include? p.id
          p 
        end
      end
    end

  declare
    def rcv
      # do something.
    end

  declare 
    def done
      # vacuous ackuous.  override me!
      pipe_out <+ pipe.map do |p| 
        p
      end
    end
end

