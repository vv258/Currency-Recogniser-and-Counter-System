      #include <16f877a.h> 
      #include <stdio.h>
      #include <string.h>
      #fuses HS,NOLVP,NOWDT,NOPROTECT
      #use delay(clock=20000000) 
      #use rs232(baud=9600,parity=N,xmit=PIN_c6,rcv=PIN_c7,bits=8,stream=PC)
      #define conveyor pin_b4
      #define capture pin_d1
      #define stop pin_d0
      #define fk pin_d2
      #define fkc pin_b6  
      #define feed pin_b5
      #BYTE port_b = 6  
   
   int check_fake()
   {unsigned int16 g,h;
     setup_timer_1(T1_EXTERNAL);
     delay_ms(600);
  set_timer1(0);
   delay_ms(100);
   g=get_timer1();
   output_high(fkc);
   delay_ms(1000);
   set_timer1(0);
   delay_ms(100);
   h=get_timer1();
    output_low(fkc);
   setup_timer_1(T1_DISABLED);
    if(h-g>10000)
  return 1;
  else 
  return 0;
   }
   
   BYTE const POSITIONS[4] = {0b0101,0b1001,0b1010,0b0110};
      
    void note_feed()
    {output_high(feed);
    delay_ms(3000);
    output_low(feed);
    }
   
  void drive_stepper( int k)
    {    static BYTE stepper_state = 0;
      BYTE i,j;
      BYTE steps=34;
      BYTE speed=100;
    char dir;
    int l;
     if(k>=0 && k<=3)
    {dir='F';
    l=k;
    }
    else if (k==4 || k==5)
    {dir='R';
    l=6-k;
    }
    else if (k==-1 || k==-2 || k==-3)
    {dir ='R';
    l=-k;
    }
     else if (k==-4 || k==-5)
     {dir='F';
     l=6+k;
     }
    
    
      for(j=0; j<l; ++j)
      {
      for(i=0; i<steps; ++i)
      {        
        delay_ms(speed);
        set_tris_b(0xf0);
        port_b = POSITIONS[ stepper_state ];
        if(dir!='F')
          stepper_state=(stepper_state+1)&(sizeof(POSITIONS)-1);
        else
          stepper_state=(stepper_state-1)&(sizeof(POSITIONS)-1);
      }
      }
    }
    
      void main()
      { char denom[5][15]={"10.","20.","50.","100.","unrecognized."};
        char s[20];
        char s2[10]="start.";
        char s3[10]="capture.";
        char s4[10]="stop.";
        char s5[10]="fake.";
       signed int p,q;
       int fake=0;

       while(1)
         {   
            p=0;
            while(1)
            {
           
             while(!kbhit());
             gets(s);
             if(!strcmp(s,s2))
                {output_high(conveyor);
                 break;
                }
            }
      
            while(input_state(stop))
                {  q=p;
                note_feed();
             
                         while(1)
                            { if(input_state(fk))
                                 break;
                              delay_ms(50);
                              }
                              
                              
                delay_ms(750);
                output_low(conveyor);
                fake=check_fake();
                
                
                if(!fake)
                { output_high(conveyor);
                             
                         while(1)
                        { if(input_state(capture))
                           break;
                        delay_ms(50);
                        }
                
                delay_ms(800);
                output_low(conveyor);
                fprintf(PC,s3);
                while(!kbhit());
                gets(s);
                for(p=0;p<5;p++)
                   {if(!strcmp(s,denom[p]))
                       break;
                   }
                }
  
                else
                {fprintf(PC,s5);
                delay_ms(10);
                fake=0;
                p=5;
                
                 while(1)
            {
             while(!kbhit());
             gets(s);
             if(!strcmp(s,s5))
               break;
            }
                 }
                 
                drive_stepper(p-q);
                output_high(conveyor);
                }
    
                fprintf(PC,s4);
                delay_ms(4000);
            output_low(conveyor);
            drive_stepper(0-p);
           
           }
        }
