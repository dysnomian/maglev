#TODO: error without scutil
#TODO: add linux vpn management
module VpnStatus
  extend self

  def list
    `scutil --nc list`
      .split("\n")
      .drop(1)
      .map { |str| vpn_attributes(str) }
  end

  def connected?
    !connected_vpns.empty?
  end


  def connected_vpns
    list.select {|vpn| vpn[:status] == "Connected" }
      .map {|vpn| vpn[:name]}
  end

  def vpn_attributes(status_string)
    return {} unless status_string.is_a?(String)
    status_array = status_string.split(" ")

    {
      status: status_array[1].gsub(/[()]/, ""),
      name: status_array[4]
    }
  end
end
