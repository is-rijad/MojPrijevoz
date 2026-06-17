using Microsoft.AspNetCore.Http;

namespace MojPrijevoz.Services.FileStorage;

public interface IFileStorageService {
    Task<string> SaveAsync(IFormFile file);
    Task DeleteAsync(string fileName);
}