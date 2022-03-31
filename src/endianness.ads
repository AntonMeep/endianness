with Ada.Streams; use Ada.Streams;
with Interfaces;  use Interfaces;

package Endianness with
   Pure,
   Preelaborate,
   SPARK_Mode => On
is
   generic
      type Source is (<>);
   function Swap_Endian (Value : Source) return Source with
      Global => null,
      Pre => Source'Size = 8 or else Source'Size = 16 or else Source'Size = 32
      or else Source'Size = 64;

   generic
      type Source is (<>);
   function Native_To_Big_Endian
     (Value : Source) return Stream_Element_Array with
      Global => null,
      Pre => Source'Size = 8 or else Source'Size = 16 or else Source'Size = 32
      or else Source'Size = 64,
      Post => Native_To_Big_Endian'Result'Length =
      Source'Max_Size_In_Storage_Elements;

   generic
      type Source is (<>);
   function Native_To_Little_Endian
     (Value : Source) return Stream_Element_Array with
      Global => null,
      Pre => Source'Size = 8 or else Source'Size = 16 or else Source'Size = 32
      or else Source'Size = 64,
      Post => Native_To_Little_Endian'Result'Length =
      Source'Max_Size_In_Storage_Elements;

   generic
      type Target is (<>);
   function Big_Endian_To_Native
     (Value : Stream_Element_Array) return Target with
      Global => null,
      Pre    =>
      (Target'Size = 8 or else Target'Size = 16 or else Target'Size = 32
       or else Target'Size = 64)
      and then Value'Length = Target'Max_Size_In_Storage_Elements;

   generic
      type Target is (<>);
   function Little_Endian_To_Native
     (Value : Stream_Element_Array) return Target with
      Global => null,
      Pre    =>
      (Target'Size = 8 or else Target'Size = 16 or else Target'Size = 32
       or else Target'Size = 64)
      and then Value'Length = Target'Max_Size_In_Storage_Elements;
end Endianness;
