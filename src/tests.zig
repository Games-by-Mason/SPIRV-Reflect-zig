const c = @cImport({
    @cInclude("spirv_reflect/spirv_reflect.h");
});
const spirv_reflect = @import("spirv_reflect");

const std = @import("std");
const testing = std.testing;

fn checkType(importc: type, zig: type) !void {
    const importc_fields = std.meta.fields(importc);
    const zig_fields = std.meta.fields(zig);
    inline for (importc_fields, zig_fields) |importc_field, zig_field| {
        try testing.expectEqualStrings(importc_field.name, zig_field.name);
        try testing.expectEqual(@sizeOf(importc_field.type), @sizeOf(zig_field.type));
        try testing.expectEqual(importc_field.alignment, zig_field.alignment);
        try testing.expectEqual(importc_field.alignment, zig_field.alignment);
        try testing.expectEqual(
            @offsetOf(importc, importc_field.name),
            @offsetOf(zig, zig_field.name),
        );
    }
    try testing.expectEqual(@sizeOf(importc), @sizeOf(zig));
}

test "sizes" {
    try checkType(c.SpvReflectShaderModule, spirv_reflect.ShaderModule);
    try checkType(c.SpvReflectShaderModule, spirv_reflect.ShaderModule);
    try checkType(c.SpvReflectDescriptorBinding, spirv_reflect.DescriptorBinding);
    try checkType(c.SpvReflectEntryPoint, spirv_reflect.EntryPoint);
    try checkType(c.SpvReflectCapability, spirv_reflect.ReflectCapability);
    try checkType(c.SpvReflectTypeDescription, spirv_reflect.TypeDescription);
    try checkType(c.SpvReflectDescriptorSet, spirv_reflect.DescriptorSet);
    try checkType(c.SpvReflectInterfaceVariable, spirv_reflect.InterfaceVariable);
    try checkType(c.SpvReflectBlockVariable, spirv_reflect.BlockVariable);
    try checkType(c.SpvReflectSpecializationConstant, spirv_reflect.SpecializationConstant);
    try checkType(c.SpvReflectImageTraits, spirv_reflect.ImageTraits);
    try checkType(c.SpvReflectBindingArrayTraits, spirv_reflect.BindingArrayTraits);
    try checkType(c.SpvReflectNumericTraits, spirv_reflect.NumericTraits);
    try checkType(c.SpvReflectArrayTraits, spirv_reflect.ArrayTraits);
}
