using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using System.ComponentModel.DataAnnotations;

namespace MojPrijevoz.Services.FileStorage;

public class LocalFileStorageService : IFileStorageService {
    private readonly string _basePath;
    private readonly string _baseUrl;

    private static readonly string[] AllowedTypes = new[] { "image/jpeg", "image/png" };
    private static readonly Dictionary<string, byte[]> MagicBytes = new()
    {
        ["image/jpeg"] = new byte[] { 0xFF, 0xD8, 0xFF },
        ["image/png"] = new byte[] { 0x89, 0x50, 0x4E, 0x47 },
    };

    public LocalFileStorageService(IWebHostEnvironment env, IConfiguration config) {
        _basePath = Path.Combine(env.WebRootPath, "uploads");
        _baseUrl = config["Storage:BaseUrl"] ?? "";

        Directory.CreateDirectory(_basePath);
    }

    public async Task<string> SaveAsync(IFormFile file) {
        ValidateSize(file);
        ValidateType(file.ContentType);
        await ValidateMagicBytesAsync(file);

        var ext = GetSafeExtension(file.ContentType);
        var fileName = $"{Guid.NewGuid()}{ext}";
        var fullPath = Path.Combine(_basePath, fileName);

        await using var stream = File.Create(fullPath);
        await file.CopyToAsync(stream);

        return fileName;
    }

    public Task DeleteAsync(string fileName) {
        var fullPath = Path.GetFullPath(Path.Combine(_basePath, fileName));

        if (!fullPath.StartsWith(_basePath, StringComparison.OrdinalIgnoreCase))
            throw new InvalidOperationException("Invalid file path.");

        if (File.Exists(fullPath))
            File.Delete(fullPath);

        return Task.CompletedTask;
    }


    public string GetUrl(string fileName) => $"{_baseUrl}uploads/{fileName}";

    private static void ValidateSize(IFormFile file, long maxBytes = 5 * 1024 * 1024) {
        if (file.Length == 0) throw new ValidationException("File is empty.");
        if (file.Length > maxBytes) throw new ValidationException("File exceeds 5MB.");
    }

    private static void ValidateType(string contentType) {
        if (!AllowedTypes.Contains(contentType))
            throw new ValidationException($"Unsupported type: {contentType}");
    }

    private static async Task ValidateMagicBytesAsync(IFormFile file) {
        if (!MagicBytes.TryGetValue(file.ContentType, out var magic))
            return;

        var buffer = new byte[magic.Length];
        await using var stream = file.OpenReadStream();
        _ = await stream.ReadAsync(buffer.AsMemory(0, magic.Length));

        if (!buffer.Take(magic.Length).SequenceEqual(magic))
            throw new ValidationException("File content does not match declared type.");
    }

    private static string GetSafeExtension(string contentType) => contentType switch
    {
        "image/jpeg" => ".jpg",
        "image/png" => ".png",
        "image/webp" => ".webp",
        _ => throw new InvalidOperationException("Unhandled type.")
    };
}