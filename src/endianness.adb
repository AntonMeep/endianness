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

   function Swap_Endian (Value : Source) return Source is
      use GNAT.Byte_Swapping;
   begin
      case Source'Max_Size_In_Storage_Elements is
         when 1 =>
            return Value;
         when 2 =>
            declare
               function Swap is new Swapped2 (Source);
            begin
               return Swap (Value);
            end;
         when 4 =>
            declare
               function Swap is new Swapped4 (Source);
            begin
               return Swap (Value);
            end;
         when 8 =>
            declare
               function Swap is new Swapped8 (Source);
            begin
               return Swap (Value);
            end;
         when others =>
            raise Constraint_Error with "`Source'Size` is not 16, 32 or 64";
      end case;
   end Swap_Endian;

   function Native_To_Big_Endian (Value : Source) return Stream_Element_Array
   is
      function Swap is new Swap_Endian (Source);
      function Split is new Split_Into_Bytes (Source);
   begin
      return
        Split
          (if Default_Bit_Order /= High_Order_First then Swap (Value)
           else Value);
   end Native_To_Big_Endian;

   function Native_To_Little_Endian
     (Value : Source) return Stream_Element_Array
   is
      function Swap is new Swap_Endian (Source);
      function Split is new Split_Into_Bytes (Source);
   begin
      return
        Split
          (if Default_Bit_Order /= Low_Order_First then Swap (Value)
           else Value);
   end Native_To_Little_Endian;

   function Big_Endian_To_Native (Value : Stream_Element_Array) return Target
   is
      function Swap is new Swap_Endian (Target);
      function Assemble is new Assemble_From_Bytes (Target);
   begin
      return
        (if Default_Bit_Order /= High_Order_First then Swap (Assemble (Value))
         else Assemble (Value));
   end Big_Endian_To_Native;

   function Little_Endian_To_Native
     (Value : Stream_Element_Array) return Target
   is
      function Swap is new Swap_Endian (Target);
      function Assemble is new Assemble_From_Bytes (Target);
   begin
      return
        (if Default_Bit_Order /= Low_Order_First then Swap (Assemble (Value))
         else Assemble (Value));
   end Little_Endian_To_Native;

   function Split_Into_Bytes (Value : Source) return Stream_Element_Array is
      subtype Output_Type is
        Stream_Element_Array (0 .. Source'Max_Size_In_Storage_Elements - 1);

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
