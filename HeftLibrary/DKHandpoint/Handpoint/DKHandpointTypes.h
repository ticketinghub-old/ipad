//
//  DKHandpointTypes.h
//  POSTest
//
//  Created by Hjalti Jakobsson on 3.9.2013.
//  Copyright (c) 2013 Hjalti Jakobsson. All rights reserved.
//

#import "HeftClient.h"
#import <ExternalAccessory/ExternalAccessory.h>
#import "DKPOSClientTransactionInfo.h"

typedef NS_ENUM(NSInteger, DKHandpointDeviceStatus)
{
    EFT_PP_STATUS_SUCCESS	                	= 0x0001,
    EFT_PP_STATUS_INVALID_DATA	            	= 0x0002,
    EFT_PP_STATUS_PROCESSING_ERROR	        	= 0x0003,
    EFT_PP_STATUS_COMMAND_NOT_ALLOWED	    	= 0x0004,
    EFT_PP_STATUS_NOT_INITIALISED	        	= 0x0005,
    EFT_PP_STATUS_CONNECT_TIMEOUT	        	= 0x0006,
    EFT_PP_STATUS_CONNECT_ERROR	            	= 0x0007,
    EFT_PP_STATUS_SENDING_ERROR	            	= 0x0008,
    EFT_PP_STATUS_RECEIVEING_ERROR	        	= 0x0009,
    EFT_PP_STATUS_NO_DATA_AVAILABLE	        	= 0x000a,
    EFT_PP_STATUS_TRANS_NOT_ALLOWED	        	= 0x000b,
    EFT_PP_STATUS_UNSUPPORTED_CURRENCY	    	= 0x000c,
    EFT_PP_STATUS_NO_HOST_AVAILABLE	        	= 0x000d,
    EFT_PP_STATUS_CARD_READER_ERROR	        	= 0x000e,
    EFT_PP_STATUS_CARD_READING_FAILED	    	= 0x000f,
    EFT_PP_STATUS_INVALID_CARD	            	= 0x0010,
    EFT_PP_STATUS_INPUT_TIMEOUT	            	= 0x0011,
    EFT_PP_STATUS_USER_CANCELLED	        	= 0x0012,
    EFT_PP_STATUS_INVALID_SIGNATURE	        	= 0x0013,
    EFT_PP_STATUS_WAITING_CARD	            	= 0x0014,
    EFT_PP_STATUS_CARD_INSERTED	            	= 0x0015,
    EFT_PP_STATUS_APPLICATION_SELECTION	    	= 0x0016,
    EFT_PP_STATUS_APPLICATION_CONFIRMATION		= 0x0017,
    EFT_PP_STATUS_AMOUNT_VALIDATION	        	= 0x0018,
    EFT_PP_STATUS_PIN_INPUT	                	= 0x0019,
    EFT_PP_STATUS_MANUAL_CARD_INPUT	        	= 0x001a,
    EFT_PP_STATUS_WAITING_CARD_REMOVAL      	= 0x001b,
    EFT_PP_STATUS_TIP_INPUT                 	= 0x001c,
    EFT_PP_STATUS_SHARED_SECRET_INVALID			= 0x001d,
    EFT_PP_STATUS_CONNECTING					= 0x0020,
    EFT_PP_STATUS_SENDING						= 0x0021,
    EFT_PP_STATUS_RECEIVEING					= 0x0022,
    EFT_PP_STATUS_DISCONNECTING					= 0x0023
};

typedef NS_ENUM(NSInteger, DKHandpointTransactionStatus)
{
    EFT_TRANS_UNDEFINED 	            	    = 0x0000,
    EFT_TRANS_APPROVED 							= 0x0001,
    EFT_TRANS_DECLINED  						= 0x0002,
    EFT_TRANS_PROCESSED 						= 0x0003,
    EFT_TRANS_NOT_PROCESSED 					= 0x0004,
    EFT_TRANS_CANCELLED							= 0x0005,
    EFT_TRANS_DEVICE_RESET_MASK					= 0x0080,
    
    /*
     Have to add some of the codes from the enum above in here
     because for some rease responseFinanceStatus: can also be
     called with those codes and it's impossible to distinguish
     otherise.
    */
    
    EFT_TRANS_USER_CANCELLED                    = 0x0012,
    EFT_TRANS_INPUT_TIMEOUT                     = 0x0011,
    EFT_TRANS_CARD_READING_FAILED               = 0x000f
};

//Info Dictionary Keys

extern NSString *const kDKHandppointTransactionIDKey;
extern NSString *const kDKHandpointDeviceSerialKey;
extern NSString *const kDKHandpointTransactionAuthorisationCodeKey;
extern NSString *const kDKHandpointTransactionCardIssuerNameKey;

