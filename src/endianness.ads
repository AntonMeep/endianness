with Ada.Streams; use Ada.Streams;
with Interfaces;  use Interfaces;

package Endianness with
   Pure,
   Preelaborate,
   SPARK_Mode => On
is
   generic
      type Source is (<>);
   procedure Swap_Endian (Value : aliased in out Source) with
      Global => null;

   generic
      type Source is (<>);
   function Native_To_Big_Endian
     (Value : Source) return Stream_Element_Array with
      Global => null;

   generic
      type Source is (<>);
   function Native_To_Little_Endian
     (Value : Source) return Stream_Element_Array with
      Global => null;

   generic
      type Target is (<>);
   function Big_Endian_To_Native
     (Value : Stream_Element_Array) return Target with
      Global => null;

   generic
      type Target is (<>);
   function Little_Endian_To_Native
     (Value : Stream_Element_Array) return Target with
      Global => null;
end Endianness;
