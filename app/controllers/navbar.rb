# 用于渲染导航条的数据的类
class Navbar
  
  attr_accessor :id
  attr_accessor :name
  attr_accessor :num

  def initialize id, name, num
    @id = id
    @name = name
    @num = num
  end

end
