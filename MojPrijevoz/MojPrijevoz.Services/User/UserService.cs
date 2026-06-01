using MapsterMapper;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using MojPrijevoz.Database;
using MojPrijevoz.Model.BaseModels;
using MojPrijevoz.Model.Exceptions;
using MojPrijevoz.Model.Requests.User;
using MojPrijevoz.Model.Responses.User;
using MojPrijevoz.Services.Authorization;
using MojPrijevoz.Services.BaseServices;
using MojPrijevoz.Services.FileStorage;
using MojPrijevoz.Services.FormRequests.User;

namespace MojPrijevoz.Services.User;

public class UserService : BaseCrudService<Database.User, UserInsertRequest, UserUpdateFormRequest, UserResponse,
    BaseSearchObject> {

    public UserService(MojPrijevozDbContext context, IMapper mapper,
        IHttpContextAccessor httpContextAccessor,
        AuthorizationService authorizationService,
        IFileStorageService fileStorageService) : base(context, mapper, authorizationService, fileStorageService) {
    }

    protected override async Task BeforeInsert(UserInsertRequest request) {
        await base.BeforeInsert(request);
        if (await _dbContext.Users.AnyAsync(u => u.Username == request.Username || u.Email == request.Email))
            throw new BadRequestException("Korisničko ime ili email već postoji.");
    }

    protected override Database.User MapToInsertEntity(UserInsertRequest request) {
        var userInsertRequest = _mapper.Map<Database.User>(request);
        _authorizationService.CreatePassword(request.Password, request.PasswordAgain, out var passwordHash,
            out var passwordSalt);
        (userInsertRequest.PasswordHash, userInsertRequest.PasswordSalt) = (passwordHash, passwordSalt);
        return userInsertRequest;
    }

    protected override async Task AfterInsert(Database.User entity, MojPrijevozDbContext dbContext) {
        await base.AfterInsert(entity, dbContext);
        if (entity.UserProfiles == null)
            entity.UserProfiles = new List<Database.UserProfile>();
        entity.UserProfiles.Add(new Database.UserProfile
        {
            ProfileType = ProfileType.Passenger,
            User = entity
        });
        await dbContext.SaveChangesAsync();
    }

    protected override Task BeforeUpdate(int id, UserUpdateFormRequest request, Database.User entity) {
        base.BeforeUpdate(id, request, entity);
        if (request.OldPassword is not null || request.Password is not null || request.PasswordAgain is not null) {
            if (!_authorizationService.VerifyPassword(request.OldPassword ?? string.Empty, entity.PasswordHash,
                    entity.PasswordSalt))
                throw new BadRequestException("Stara lozinka nije ispravna.");
            if (request.Password is null || request.PasswordAgain is null)
                throw new BadRequestException("Nove lozinke moraju biti unesene.");
            _authorizationService.CreatePassword(request.Password, request.PasswordAgain, out var passwordHash,
                out var passwordSalt);
            (entity.PasswordHash, entity.PasswordSalt) = (passwordHash, passwordSalt);
            (request.Password, request.PasswordAgain, request.OldPassword) = (null, null, null);
        }

        return Task.CompletedTask;
    }
}