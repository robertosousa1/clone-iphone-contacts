//
//  Contato.m
//  ContatosIP67
//
//  Created by Carlos A Savi on 25/03/17.
//  Copyright © 2017 Carlos A Savi. All rights reserved.
//

#import "Contato.h"

@implementation Contato

// Capítulo 17 - deixando a responsabilidade com o Core Data
@dynamic nome,telefone,endereco,site,latitude,longitude,foto;

-(NSString *)description {
    return [NSString stringWithFormat:@"Nome: %@, Telefone: %@,            Endereço: %@, Site: %@, Latitude: %@, Longitude: %@", self.nome, self.telefone, self.endereco, self.site, self.latitude, self.longitude];
}

// Capítulo 16
- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake([self.latitude doubleValue],
                                      [self.longitude doubleValue]);
}

- (NSString *)title {
    return self.nome;
}
- (NSString *)subtitle {
    return self.site;
}

@end
