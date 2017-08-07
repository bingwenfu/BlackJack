import keras
from keras.models import Sequential
from keras.layers.normalization import BatchNormalization
from keras.optimizers import Adam
from keras.layers import Dense, Dropout, Activation, Flatten
from keras.layers import Conv2D, MaxPooling2D


def model_name():
	return "conv-12"

def initialize_model(input_shape, output_dimension):

	model = Sequential()

	model.add(Dense(
		input_shape[0]*10, 
		input_shape=input_shape,
		activation='relu', 
		kernel_initializer='random_uniform', 
		bias_initializer='random_uniform'
	))
	model.add(Dropout(0.25))

	model.add(Dense(
		input_shape[0]*10, 
		activation='relu', 
		kernel_initializer='random_uniform', 
		bias_initializer='random_uniform'
	))
	model.add(Dropout(0.25))

	model.add(Dense(
		output_dimension, 
		activation='softmax', 
		kernel_initializer='random_uniform', 
		bias_initializer='random_uniform'
	))

	optimizer = Adam(lr=0.01)
	model.compile(loss='categorical_crossentropy', optimizer=optimizer)

	return model

if __name__ == "__main__":
	model = initialize_model((57, ), 1)
	model.summary()


