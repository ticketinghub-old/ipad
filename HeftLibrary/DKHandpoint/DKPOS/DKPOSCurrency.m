//
//  DKPosCurrency.m
//  POSTest
//
//  Created by Hjalti Jakobsson on 3.9.2013.
//  Copyright (c) 2013 Hjalti Jakobsson. All rights reserved.
//

#import "DKPOSCurrency.h"
//#import "DKUtils.h"

static NSDictionary *currencyTypes;

@implementation DKPOSCurrency

- (id)init
{
    if(self = [super init])
    {
        [self setupCodes];
    }
    
    return self;
}

+ (instancetype)instance
{
    static dispatch_once_t pred;
    static DKPOSCurrency *sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (NSString*)currentCurrencyNumber
{
    NSLocale *locale = [NSLocale currentLocale];// changed
    NSString *currencyCode = [locale objectForKey:NSLocaleCurrencyCode];
    
    return [self currencyNumberForCode:currencyCode];
}

- (NSString*)currencyNumberForCode:(NSString*)code
{
    return currencyTypes[code][@"number"];
}

- (void)setupCodes
{
    currencyTypes = @{@"AED": @{ @"number": @"0784", @"e": @2 },
                      @"AFN": @{ @"number": @"0971", @"e": @2 },
                      @"ALL": @{ @"number": @"0008", @"e": @2 },
                      @"AMD": @{ @"number": @"0051", @"e": @2 },
                      @"ANG": @{ @"number": @"0532", @"e": @2 },
                      @"AOA": @{ @"number": @"0973", @"e": @2 },
                      @"ARS": @{ @"number": @"0032", @"e": @2 },
                      @"AUD": @{ @"number": @"0036", @"e": @2 },
                      @"AWG": @{ @"number": @"0533", @"e": @2 },
                      @"AZN": @{ @"number": @"0944", @"e": @2 },
                      @"BAM": @{ @"number": @"0977", @"e": @2 },
                      @"BBD": @{ @"number": @"0052", @"e": @2 },
                      @"BDT": @{ @"number": @"0050", @"e": @2 },
                      @"BGN": @{ @"number": @"0975", @"e": @2 },
                      @"BHD": @{ @"number": @"0048", @"e": @3 },
                      @"BIF": @{ @"number": @"0108", @"e": @0 },
                      @"BMD": @{ @"number": @"0060", @"e": @2 },
                      @"BND": @{ @"number": @"0096", @"e": @2 },
                      @"BOB": @{ @"number": @"0068", @"e": @2 },
                      @"BOV": @{ @"number": @"0984", @"e": @2 },
                      @"BRL": @{ @"number": @"0986", @"e": @2 },
                      @"BSD": @{ @"number": @"0044", @"e": @2 },
                      @"BTN": @{ @"number": @"0064", @"e": @2 },
                      @"BWP": @{ @"number": @"0072", @"e": @2 },
                      @"BYR": @{ @"number": @"0974", @"e": @0 },
                      @"BZD": @{ @"number": @"0084", @"e": @2 },
                      @"CAD": @{ @"number": @"0124", @"e": @2 },
                      @"CDF": @{ @"number": @"0976", @"e": @2 },
                      @"CHE": @{ @"number": @"0947", @"e": @2 },
                      @"CHF": @{ @"number": @"0756", @"e": @2 },
                      @"CHW": @{ @"number": @"0948", @"e": @2 },
                      @"CLF": @{ @"number": @"0990", @"e": @0 },
                      @"CLP": @{ @"number": @"0152", @"e": @0 },
                      @"CNY": @{ @"number": @"0156", @"e": @2 },
                      @"COP": @{ @"number": @"0170", @"e": @2 },
                      @"COU": @{ @"number": @"0970", @"e": @2 },
                      @"CRC": @{ @"number": @"0188", @"e": @2 },
                      @"CUC": @{ @"number": @"0931", @"e": @2 },
                      @"CUP": @{ @"number": @"0192", @"e": @2 },
                      @"CVE": @{ @"number": @"0132", @"e": @0 },
                      @"CZK": @{ @"number": @"0203", @"e": @2 },
                      @"DJF": @{ @"number": @"0262", @"e": @0 },
                      @"DKK": @{ @"number": @"0208", @"e": @2 },
                      @"DOP": @{ @"number": @"0214", @"e": @2 },
                      @"DZD": @{ @"number": @"0012", @"e": @2 },
                      @"EGP": @{ @"number": @"0818", @"e": @2 },
                      @"ERN": @{ @"number": @"0232", @"e": @2 },
                      @"ETB": @{ @"number": @"0230", @"e": @2 },
                      @"EUR": @{ @"number": @"0978", @"e": @2 },
                      @"FJD": @{ @"number": @"0242", @"e": @2 },
                      @"FKP": @{ @"number": @"0238", @"e": @2 },
                      @"GBP": @{ @"number": @"0826", @"e": @2 },
                      @"GEL": @{ @"number": @"0981", @"e": @2 },
                      @"GHS": @{ @"number": @"0936", @"e": @2 },
                      @"GIP": @{ @"number": @"0292", @"e": @2 },
                      @"GMD": @{ @"number": @"0270", @"e": @2 },
                      @"GNF": @{ @"number": @"0324", @"e": @0 },
                      @"GTQ": @{ @"number": @"0320", @"e": @2 },
                      @"GYD": @{ @"number": @"0328", @"e": @2 },
                      @"HKD": @{ @"number": @"0344", @"e": @2 },
                      @"HNL": @{ @"number": @"0340", @"e": @2 },
                      @"HRK": @{ @"number": @"0191", @"e": @2 },
                      @"HTG": @{ @"number": @"0332", @"e": @2 },
                      @"HUF": @{ @"number": @"0348", @"e": @2 },
                      @"IDR": @{ @"number": @"0360", @"e": @0 },
                      @"ILS": @{ @"number": @"0376", @"e": @2 },
                      @"INR": @{ @"number": @"0356", @"e": @2 },
                      @"IQD": @{ @"number": @"0368", @"e": @3 },
                      @"IRR": @{ @"number": @"0364", @"e": @0 },
                      @"ISK": @{ @"number": @"0352", @"e": @0 },
                      @"JMD": @{ @"number": @"0388", @"e": @2 },
                      @"JOD": @{ @"number": @"0400", @"e": @3 },
                      @"JPY": @{ @"number": @"0392", @"e": @0 },
                      @"KES": @{ @"number": @"0404", @"e": @2 },
                      @"KGS": @{ @"number": @"0417", @"e": @2 },
                      @"KHR": @{ @"number": @"0116", @"e": @2 },
                      @"KMF": @{ @"number": @"0174", @"e": @0 },
                      @"KPW": @{ @"number": @"0408", @"e": @0 },
                      @"KRW": @{ @"number": @"0410", @"e": @0 },
                      @"KWD": @{ @"number": @"0414", @"e": @3 },
                      @"KYD": @{ @"number": @"0136", @"e": @2 },
                      @"KZT": @{ @"number": @"0398", @"e": @2 },
                      @"LAK": @{ @"number": @"0418", @"e": @0 },
                      @"LBP": @{ @"number": @"0422", @"e": @0 },
                      @"LKR": @{ @"number": @"0144", @"e": @2 },
                      @"LRD": @{ @"number": @"0430", @"e": @2 },
                      @"LSL": @{ @"number": @"0426", @"e": @2 },
                      @"LTL": @{ @"number": @"0440", @"e": @2 },
                      @"LVL": @{ @"number": @"0428", @"e": @2 },
                      @"LYD": @{ @"number": @"0434", @"e": @3 },
                      @"MAD": @{ @"number": @"0504", @"e": @2 },
                      @"MDL": @{ @"number": @"0498", @"e": @2 },
                      @"MGA": @{ @"number": @"0969", @"e": @0 },
                      @"MKD": @{ @"number": @"0807", @"e": @0 },
                      @"MMK": @{ @"number": @"0104", @"e": @0 },
                      @"MNT": @{ @"number": @"0496", @"e": @2 },
                      @"MOP": @{ @"number": @"0446", @"e": @2 },
                      @"MRO": @{ @"number": @"0478", @"e": @0 },
                      @"MUR": @{ @"number": @"0480", @"e": @2 },
                      @"MVR": @{ @"number": @"0462", @"e": @2 },
                      @"MWK": @{ @"number": @"0454", @"e": @2 },
                      @"MXN": @{ @"number": @"0484", @"e": @2 },
                      @"MXV": @{ @"number": @"0979", @"e": @2 },
                      @"MYR": @{ @"number": @"0458", @"e": @2 },
                      @"MZN": @{ @"number": @"0943", @"e": @2 },
                      @"NAD": @{ @"number": @"0516", @"e": @2 },
                      @"NGN": @{ @"number": @"0566", @"e": @2 },
                      @"NIO": @{ @"number": @"0558", @"e": @2 },
                      @"NOK": @{ @"number": @"0578", @"e": @2 },
                      @"NPR": @{ @"number": @"0524", @"e": @2 },
                      @"NZD": @{ @"number": @"0554", @"e": @2 },
                      @"OMR": @{ @"number": @"0512", @"e": @3 },
                      @"PAB": @{ @"number": @"0590", @"e": @2 },
                      @"PEN": @{ @"number": @"0604", @"e": @2 },
                      @"PGK": @{ @"number": @"0598", @"e": @2 },
                      @"PHP": @{ @"number": @"0608", @"e": @2 },
                      @"PKR": @{ @"number": @"0586", @"e": @2 },
                      @"PLN": @{ @"number": @"0985", @"e": @2 },
                      @"PYG": @{ @"number": @"0600", @"e": @0 },
                      @"QAR": @{ @"number": @"0634", @"e": @2 },
                      @"RON": @{ @"number": @"0946", @"e": @2 },
                      @"RSD": @{ @"number": @"0941", @"e": @2 },
                      @"RUB": @{ @"number": @"0643", @"e": @2 },
                      @"RWF": @{ @"number": @"0646", @"e": @0 },
                      @"SAR": @{ @"number": @"0682", @"e": @2 },
                      @"SBD": @{ @"number": @"0090", @"e": @2 },
                      @"SCR": @{ @"number": @"0690", @"e": @2 },
                      @"SDG": @{ @"number": @"0938", @"e": @2 },
                      @"SEK": @{ @"number": @"0752", @"e": @2 },
                      @"SGD": @{ @"number": @"0702", @"e": @2 },
                      @"SHP": @{ @"number": @"0654", @"e": @2 },
                      @"SLL": @{ @"number": @"0694", @"e": @0 },
                      @"SOS": @{ @"number": @"0706", @"e": @2 },
                      @"SRD": @{ @"number": @"0968", @"e": @2 },
                      @"SSP": @{ @"number": @"0728", @"e": @2 },
                      @"STD": @{ @"number": @"0678", @"e": @0 },
                      @"SYP": @{ @"number": @"0760", @"e": @2 },
                      @"SZL": @{ @"number": @"0748", @"e": @2 },
                      @"THB": @{ @"number": @"0764", @"e": @2 },
                      @"TJS": @{ @"number": @"0972", @"e": @2 },
                      @"TMT": @{ @"number": @"0934", @"e": @2 },
                      @"TND": @{ @"number": @"0788", @"e": @3 },
                      @"TOP": @{ @"number": @"0776", @"e": @2 },
                      @"TRY": @{ @"number": @"0949", @"e": @2 },
                      @"TTD": @{ @"number": @"0780", @"e": @2 },
                      @"TWD": @{ @"number": @"0901", @"e": @2 },
                      @"TZS": @{ @"number": @"0834", @"e": @2 },
                      @"UAH": @{ @"number": @"0980", @"e": @2 },
                      @"UGX": @{ @"number": @"0800", @"e": @2 },
                      @"USD": @{ @"number": @"0840", @"e": @2 },
                      @"USN": @{ @"number": @"0997", @"e": @2 },
                      @"USS": @{ @"number": @"0998", @"e": @2 },
                      @"UYI": @{ @"number": @"0940", @"e": @0 },
                      @"UYU": @{ @"number": @"0858", @"e": @2 },
                      @"UZS": @{ @"number": @"0860", @"e": @2 },
                      @"VEF": @{ @"number": @"0937", @"e": @2 },
                      @"VND": @{ @"number": @"0704", @"e": @0 },
                      @"VUV": @{ @"number": @"0548", @"e": @0 },
                      @"WST": @{ @"number": @"0882", @"e": @2 },
                      @"XAF": @{ @"number": @"0950", @"e": @0 },
                      @"XAG": @{ @"number": @"0961" },
                      @"XAU": @{ @"number": @"0959" },
                      @"XBA": @{ @"number": @"0955" },
                      @"XBB": @{ @"number": @"0956" },
                      @"XBC": @{ @"number": @"0957" },
                      @"XBD": @{ @"number": @"0958" },
                      @"XCD": @{ @"number": @"0951", @"e": @2 },
                      @"XDR": @{ @"number": @"0960" },
                      @"XFU": @{ @"number": @"0" },
                      @"XOF": @{ @"number": @"0952", @"e": @0 },
                      @"XPD": @{ @"number": @"0964" },
                      @"XPF": @{ @"number": @"0953", @"e": @0 },
                      @"XPT": @{ @"number": @"0962" },
                      @"XTS": @{ @"number": @"0963" },
                      @"XXX": @{ @"number": @"0999" },
                      @"YER": @{ @"number": @"0886", @"e": @2 },
                      @"ZAR": @{ @"number": @"0710", @"e": @2 },
                      @"ZMW": @{ @"number": @"0967", @"e": @2 },
                      };
}

@end
