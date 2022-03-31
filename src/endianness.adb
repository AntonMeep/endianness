pragma Ada_2012;

with Ada.Unchecked_Conversion;
with GNAT.Byte_Swapping;
with System; use System;

package body Endianness is
   generic
      type Source is (<>);
   function Split_Into_Bytes (Value : Source) return Stream_Element_Array;

   generic
      type Target is (<>);
   function Assemble_From_Bytes (Value : Stream_Element_Array) return Target;

   procedure Swap_Endian (Value : aliased in out Source) is
      use GNAT.Byte_Swapping;
   begin
      case Value'Size is
         when 8 =>
            null;
         when 16 =>
            Swap2 (Value'Address);
         when 32 =>
            Swap4 (Value'Address);
         when 64 =>
            Swap8 (Value'Address);
         when others =>
            raise Constraint_Error with "`Source'Size` is not 16, 32 or 64";
      end case;
   end Swap_Endian;

   function Native_To_Big_Endian (Value : Source) return Stream_Element_Array
   is
      procedure Swap is new Swap_Endian (Source);
      function Split is new Split_Into_Bytes (Source);

      Value_Copy : aliased Source := Value;
   begin
      if Default_Bit_Order /= High_Order_First then
         Swap (Value_Copy);
      end if;
      return Split (Value_Copy);
   end Native_To_Big_Endian;

   function Native_To_Little_Endian
     (Value : Source) return Stream_Element_Array
   is
      procedure Swap is new Swap_Endian (Source);
      function Split is new Split_Into_Bytes (Source);

      Value_Copy : aliased Source := Value;
   begin
      if Default_Bit_Order /= Low_Order_First then
         Swap (Value_Copy);
      end if;
      return Split (Value_Copy);
   end Native_To_Little_Endian;

   function Big_Endian_To_Native (Value : Stream_Element_Array) return Target
   is
      procedure Swap is new Swap_Endian (Target);
      function Assemble is new Assemble_From_Bytes (Target);

      Result : aliased Target := Assemble (Value);
   begin
      if Default_Bit_Order /= High_Order_First then
         Swap (Result);
      end if;
      return Result;
   end Big_Endian_To_Native;

   function Little_Endian_To_Native
     (Value : Stream_Element_Array) return Target
   is
      procedure Swap is new Swap_Endian (Target);
      function Assemble is new Assemble_From_Bytes (Target);

      Result : aliased Target := Assemble (Value);
   begin
      if Default_Bit_Order /= Low_Order_First then
         Swap (Result);
      end if;
      return Result;
   end Little_Endian_To_Native;

   function Split_Into_Bytes (Value : Source) return Stream_Element_Array is
      subtype Output_Type is Stream_Element_Array (0 .. Source'Size / 8 - 1);

      function Convert is new Ada.Unchecked_Conversion (Source, Output_Type);
   begin
      return Convert (Value);
   end Split_Into_Bytes;

   function Assemble_From_Bytes (Value : Stream_Element_Array) return Target is
      function Convert is new Ada.Unchecked_Conversion
        (Stream_Element_Array, Target);
   begin
      return Convert (Value);
   end Assemble_From_Bytes;
end Endianness;
