namespace MojPrijevoz.Services.BaseServices;

public interface IPaymentService<TRequest, TResponse> where TRequest : class where TResponse : class {
    public Task<TResponse> Handle(TRequest request);
    public Task Webhook();
    public Task CreateRefund(int fareOfferId, string paymentIntentId);
}