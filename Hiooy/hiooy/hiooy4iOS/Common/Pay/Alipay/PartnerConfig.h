//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088411106729982"
//收款支付宝账号
#define SellerID  @"gioloe@live.cn"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"r8vwiem5s5rhsr3ilat82lqbsm7vaeli"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAKgApTfib1VEdMeoh1A3K5ch+w2lYguIU/L6jiR/efr/k0MPfeYlP7ySpGQ+bTieTFS19UNv/81HFi8s/0FQsTWQ6uWsbNO6xvJoV/gbUnphvHo6A42QRWzphp0npNRozWViMeY3wcyLeYwIIkSTedIUjQexgUOVkdaoow1arwCRAgMBAAECgYAgmi91zt1oIKbA8DWCHZK5+4Aqv8NtFYGlD3ZyIsLbMKm1Q9ZcyTG7OIHqairr59xMPBtigOOVRIxLj2HhnPUmbYFXsoIE2yvdAL4EaQVnvtZDPNA2rpYHVpq3jTlmeCwnmD4HRkGOr6s0MSBuZKoEazUq4qB0Li6MQaaugEPEWQJBAM+rp0TdiPAXQIVpv8lUySDNsQ+cVuhckxY9VdrzsKvhswlCysqvAihmCEC+heAkBoS0RBZ/94lm/ZgvyspH89sCQQDPGbL+kqV4Bbj1q5Hp2PY15uTNGK40rVnpyg92in+I2ssEewNYmwtrSoKGMxUxVYglQIwNwN5AXgHC0Gnq0P8DAkBX9h4IdkldYIvstokMjwQOB/Haad8J1sRaZCpsblHDy/qYjpj01sH0OJuASPLNqJS2OuCoIxXHNj9t6bhci7OHAkAKwb72Ug+eKE3vFLZDey1up0uDC6Egw1BEQGaFNbRiG1soJGuMEqGJNRmKduTG5zZnGO8tV7MzjK5yu/iEZc6ZAkEAySiS3DGcTRJ+fa7SDNZbYRw4gQCy+eHk9+nIuSU1B1vCHreL4A0xXWxLVtwUXLQfM001ML02JxI5XjWU5FG+MQ=="

//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

#endif
