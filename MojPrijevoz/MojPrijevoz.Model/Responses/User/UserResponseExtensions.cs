namespace MojPrijevoz.Model.Responses.User;

public static class UserResponseExtensions
{
    public static void RedactPrivateFields(this UserResponse? user)
    {
        if (user == null) return;
        user.Email = null;
        user.PhoneNumber = null;
        user.BankAccountNumber = null;
    }
}
