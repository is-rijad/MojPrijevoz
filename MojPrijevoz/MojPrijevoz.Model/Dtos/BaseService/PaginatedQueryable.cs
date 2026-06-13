namespace MojPrijevoz.Model.Dtos.BaseService;

public record PaginatedQueryable<T>(
    IQueryable<T> Queryable,
    int FullCount,
    int PaginatedCount
    ) where T : class;