//
//  Contato.h
//  ContatosIP67
//
//  Created by Carlos A Savi on 25/03/17.
//  Copyright © 2017 Carlos A Savi. All rights reserved.
//

#import <Foundation/Foundation.h>
// Capítulo 14
#import <UIKit/UIKit.h>
// Capítulo 16
#import <MapKit/MKAnnotation.h>
// Capítulo 17
#import <CoreData/CoreData.h>

@interface Contato : NSManagedObject <MKAnnotation>

@property (strong) NSString *nome;
@property (strong) NSString *telefone;
@property (strong) NSString *endereco;
@property (strong) NSString *site;
// Capítulo 14
@property (strong) UIImage *foto;
// Capítulo 16
@property (strong) NSNumber *latitude;
@property (strong) NSNumber *longitude;

@end
