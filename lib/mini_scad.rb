require "mini_scad/version"

module MiniScad
  module DSL
    def none
      None.new
    end

    def cube(x, y, z, center: false)
      Cube.new(x, y, z, center: center)
    end

    def sphere(r)
      Sphere.new(r)
    end

    def cylinder(r1, r2 = r1, h, n: 16, center: false)
      Cylinder.new(r1, r2, h, n: n, center: center)
    end

    def rounded_cube4(x, y, z, r, n: 16)
      a = cylinder(r, z).translate(r,         r, 0)
      b = cylinder(r, z).translate(x - r,     r, 0)
      c = cylinder(r, z).translate(r,     y - r, 0)
      d = cylinder(r, z).translate(x - r, y - r, 0)

      (a + b + c + d).hull
    end

    def rounded_cube8(x, y, z, r, n: 16)
      a = sphere(r).translate(r,     r,     r)
      b = sphere(r).translate(r,     r,     z - r)
      c = sphere(r).translate(x - r, r,     r)
      d = sphere(r).translate(x - r, r,     z - r)
      e = sphere(r).translate(r,     y - r, r)
      f = sphere(r).translate(r,     y - r, z - r)
      g = sphere(r).translate(x - r, y - r, r)
      h = sphere(r).translate(x - r, y - r, z - r)

      (a + b + c + d + e + f + g + h).hull
    end
  end

  module Transform
    def projection
      Projection.new do
        self
      end
    end

    def translate(x, y, z)
      Translate.new(x, y, z) do
        self
      end
    end

    def mirror(x, y, z)
      Mirror.new(x, y, z) do
        self
      end
    end

    def rotate(x, y, z)
      Rotate.new(x, y, z) do
        self
      end
    end

    def scale(x, y, z)
      Scale.new(x, y, z) do
        self
      end
    end

    def color(r, g, b, a)
      Color.new(r, g, b, a) do
        self
      end
    end

    def hull
      Hull.new do
        self
      end
    end

    def |(val)
      Union.new(self, val)
    end

    def &(val)
      Intersection.new(self, val)
    end

    def +(val)
      Cons.new(self, val)
    end

    def -(val)
      Difference.new(self, val)
    end

    def render
      raise NotImplementError unless @renderer

      @renderer.()
    end
  end

  class None
    include Transform

    def initialize
      @renderer = -> { '' }
    end
  end

  class Cons
    include Transform

    def initialize(car, cdr)
      @renderer = -> { [car, cdr].map(&:render).join(' ') }
    end
  end

  class Projection
    include Transform

    def initialize(&block)
      @renderer = -> { "projection() { #{block.().render} };" }
    end
  end

  class Translate
    include Transform

    def initialize(x, y, z, &block)
      @renderer = -> do
        "translate([#{x}, #{y}, #{z}]) { #{block.().render} };"
      end
    end
  end

  class Mirror
    include Transform

    def initialize(x, y, z, &block)
      @renderer = -> do
        "mirror([#{x}, #{y}, #{z}]) { #{block.().render} };"
      end
    end
  end

  class Rotate
    include Transform

    def initialize(x, y, z, &block)
      @renderer = -> do
        "rotate([#{x}, #{y}, #{z}]) { #{block.().render} };"
      end
    end
  end

  class Scale
    include Transform

    def initialize(x, y, z, &block)
      @renderer = -> do
        "scale([#{x}, #{y}, #{z}]) { #{block.().render} };"
      end
    end
  end

  class Color
    include Transform

    def initialize(r, g, b, a, &block)
      @renderer = -> do
        "color([#{r}, #{g}, #{b}, #{a}]) { #{block.().render} };"
      end
    end
  end

  class Hull
    include Transform

    def initialize(&block)
      @renderer = -> do
        "hull() { #{block.().render} };"
      end
    end
  end

  class Union
    include Transform

    def initialize(src, dst)
      @renderer = -> do
        "union() { #{src.render} #{dst.render} };"
      end
    end
  end

  class Intersection
    include Transform

    def initialize(src, dst)
      @renderer = -> do
        "intersection() { #{src.render} #{dst.render} };"
      end
    end

    def render
      @renderer.()
    end
  end

  class Difference
    include Transform

    def initialize(src, dst)
      @renderer = -> do
        "difference() { #{src.render} #{dst.render} };"
      end
    end
  end

  class Cube
    include Transform

    def initialize(x, y, z, center: false)
      @renderer = -> do
        "cube([#{x}, #{y}, #{z}], center=#{center});"
      end
    end
  end

  class Sphere
    include Transform

    def initialize(r)
      @renderer = -> { "sphere(r=#{r});" }
    end
  end

  class Cylinder
    include Transform

    def initialize(r1, r2 = r1, h, center: false, n: 16)
      @renderer = -> do
        "cylinder(r1=#{r1}, r2=#{r2}, h=#{h}, $fn = #{n}, center=#{center});"
      end
    end
  end
end
