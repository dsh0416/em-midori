class BasicSocket
  def tcp_fast_open
    # macOS devices have DIFFERENT option from Linux and FreeBSD
    opt = (/darwin/ =~ RUBY_PLATFORM) ? 1 : 5
    # Magic number 6 may refer to Socket::SOL_TCP or Socket::IPPROTO_TCP
    self.setsockopt(6, Socket::TCP_FASTOPEN, opt) if Socket.const_defined? :TCP_FASTOPEN
    true
  rescue => _e
    # Failed for some reason
    false
  end

  if Socket.const_defined? :TCP_CORK
    def cork(option=true)
      if option
        # Enable Nagle algorithm for bandwidth improvement
        # Magic number 6 may refer to Socket::SOL_TCP or Socket::IPPROTO_TCP
        # On Linux
        self.setsockopt(6, Socket::TCP_CORK, 1)
      else
        # On Linux
        return if self.closed?
        self.setsockopt(6, Socket::TCP_CORK, 0)
      end
      nil
    end
  else
    # It's a nonsense placeholder
    def cork(option=true); end
  end
end
