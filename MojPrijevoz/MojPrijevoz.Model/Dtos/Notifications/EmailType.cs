namespace MojPrijevoz.Model.Dtos.Notifications;

public enum EmailType
{
    WelcomeEmail,
    BecomeDriverEmail,
    ResetPasswordEmail,
    PasswordChangedEmail,
    NewFareOfferEmail,
    SentFareOfferEmail,
    ReceiptFareOfferEmail,
    ReviewVisibleEmail,
    ReviewHiddenEmail,
    BecomeAdministratorEmail,
    AdministratorBannedEmail,
    AdministratorPasswordChangedEmail,
    AdministratorRoleChangedEmail,
    AdministratorRoleChangedBroadcastEmail,
    TransactionPostedEmail,
    UserRequestChangesEmail,
    UserVehicleRequestChangesEmail,
    UserBannedEmail,
    RefundSucceededEmail,
    UserActivatedEmail,
    UserVehicleActivatedEmail,
    VehicleModelUpdatedEmail,
    VehicleModelDeletedEmail,
}