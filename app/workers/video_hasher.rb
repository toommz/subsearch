class VideoHasher
  def self.compute_hash(data)
    data = JSON.parse(data)
    hash = size = data["size"]
    chunks = data["chunks"]

    chunks.each do |chunk|
      pos = chunk.index(',') + 1
      chunk.slice!(0, pos)
      chunk = Base64.decode64(chunk)
      chunk.unpack("Q*").each do |n|
        hash = hash + n & 0xffffffffffffffff
      end
    end

    [hash.to_s(16), size]
  end
end
