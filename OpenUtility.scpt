FasdUAS 1.101.10   ��   ��    k             l     ��  ��     !/usr/bin/osascript     � 	 	 & ! / u s r / b i n / o s a s c r i p t   
  
 l     ��  ��    #  Guru Inamdar Copyright 2012.     �   :   G u r u   I n a m d a r   C o p y r i g h t   2 0 1 2 .      l     ��  ��    6 0 The script provided as-is, use at your own risk     �   `   T h e   s c r i p t   p r o v i d e d   a s - i s ,   u s e   a t   y o u r   o w n   r i s k      l      ��  ��     

README 

     �    
 R E A D M E   
 
      l     ��  ��     
 Make sure     �      M a k e   s u r e   ��  l    � ����  O     �   !   O    � " # " k   
 � $ $  % & % r   
  ' ( ' l  
  )���� ) e   
  * * 4  
 �� +
�� 
proj + m    ���� ��  ��   ( o      ���� 0 firstproject firstProject &  , - , r     . / . l    0���� 0 e     1 1 n     2 3 2 1    ��
�� 
ID   3 o    ���� 0 firstproject firstProject��  ��   / o      ���� 0 	projectid 	projectID -  4 5 4 l   �� 6 7��   6 < 6set orgName to (get organization name of firstProject)    7 � 8 8 l s e t   o r g N a m e   t o   ( g e t   o r g a n i z a t i o n   n a m e   o f   f i r s t P r o j e c t ) 5  9 : 9 l   �� ; <��   ; < 6set projDir to (get project directory of firstProject)    < � = = l s e t   p r o j D i r   t o   ( g e t   p r o j e c t   d i r e c t o r y   o f   f i r s t P r o j e c t ) :  > ? > l   ��������  ��  ��   ?  @ A @ l   �� B C��   B ) # activate tab bar to find file name    C � D D F   a c t i v a t e   t a b   b a r   t o   f i n d   f i l e   n a m e A  E�� E O    � F G F k    � H H  I J I I   "������
�� .miscactvnull��� ��� null��  ��   J  K L K r   # , M N M l  # * O���� O e   # * P P n   # * Q R Q 1   ' )��
�� 
pnam R 4   # '�� S
�� 
cwin S m   % &���� ��  ��   N o      ���� 0 
myfilename 
myFileName L  T�� T O   - � U V U O   1 � W X W Q   8 � Y Z�� Y k   ; � [ [  \ ] \ l  ; ;�� ^ _��   ^ - ' If its storyboad or xib open Inspector    _ � ` ` N   I f   i t s   s t o r y b o a d   o r   x i b   o p e n   I n s p e c t o r ]  a b a Z   ; � c d���� c G   ; F e f e E   ; > g h g o   ; <���� 0 
myfilename 
myFileName h m   < = i i � j j  . s t o r y b o a r d f E   A D k l k o   A B���� 0 
myfilename 
myFileName l m   B C m m � n n  . x i b d O   I � o p o O   R � q r q O   ] � s t s O   h � u v u O   s � w x w I  ~ ��� y��
�� .prcsclicuiel    ��� uiel y 4   ~ ��� z
�� 
menI z m   � � { { � | | . S h o w   I d e n t i t y   I n s p e c t o r��   x 4   s {�� }
�� 
menE } m   w z ~ ~ �    U t i l i t i e s v 4   h p�� �
�� 
menI � m   l o � � � � �  U t i l i t i e s t 4   ] e�� �
�� 
menE � m   a d � � � � �  V i e w r 4   R Z�� �
�� 
mbri � m   V Y � � � � �  V i e w p 4   I O�� �
�� 
mbar � m   M N���� ��  ��   b  ��� � l  � ���������  ��  ��  ��   Z R      ������
�� .ascrerr ****      � ****��  ��  ��   X 4   1 5�� �
�� 
pcap � m   3 4 � � � � � 
 X c o d e V m   - . � ��                                                                                  sevs  alis    �  Macintosh HD               �i�H+   (�TSystem Events.app                                               +Ç�Ɖ        ����  	                CoreServices    �i�o      ���     (�T (�N (�M  =Macintosh HD:System: Library: CoreServices: System Events.app   $  S y s t e m   E v e n t s . a p p    M a c i n t o s h   H D  -System/Library/CoreServices/System Events.app   / ��  ��   G m     � ��                                                                                      @ alis    H  Macintosh HD               �i�H+   (�q	Xcode.app                                                       �̷>        ����  	                Applications    �i�o      ̷vD     (�q  $Macintosh HD:Applications: Xcode.app   	 X c o d e . a p p    M a c i n t o s h   H D  Applications/Xcode.app  / ��  ��   # 1    ��
�� 
awks ! m      � ��                                                                                      @ alis    H  Macintosh HD               �i�H+   (�q	Xcode.app                                                       �̷>        ����  	                Applications    �i�o      ̷vD     (�q  $Macintosh HD:Applications: Xcode.app   	 X c o d e . a p p    M a c i n t o s h   H D  Applications/Xcode.app  / ��  ��  ��  ��       �� � ���   � ��
�� .aevtoappnull  �   � **** � �� ����� � ���
�� .aevtoappnull  �   � **** � k     � � �  ����  ��  ��   �   �  ������������������� ��� � i m������ ��� ��� � ~ {������
�� 
awks
�� 
proj�� 0 firstproject firstProject
�� 
ID  �� 0 	projectid 	projectID
�� .miscactvnull��� ��� null
�� 
cwin
�� 
pnam�� 0 
myfilename 
myFileName
�� 
pcap
�� 
bool
�� 
mbar
�� 
mbri
�� 
menE
�� 
menI
�� .prcsclicuiel    ��� uiel��  ��  �� �� �*�, �*�k/EE�O��,EE�O� �*j O*�k/�,EE�O� p*��/ h _��
 ���& K*a k/ >*a a / 2*a a / &*a a / *a a / *a a /j UUUUUY hOPW X  hUUUUUascr  ��ޭ