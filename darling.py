import torch
import numpy as np
import torch.nn as nn
from torch.nn.utils import spectral_norm
import torch.nn.init as init

class Darling:
    
    def __init__(self, dataset = None):
        self.n_epoch = 20
        self.device = torch.device('cpu')
        self.d = dataset.shape[1]
        self.dataset = torch.FloatTensor(dataset).to(self.device)
        self.f = Test(self.d, num_layer=2, hidden_size=20).to(self.device)
        self.g = Test(self.d, num_layer=2, hidden_size=20).to(self.device)
        self.optim_f = torch.optim.Adam(self.f.parameters(), lr=1e-2)
        self.optim_g = torch.optim.Adam(self.g.parameters(), lr=1e-2)

    def darling_test(self): 
        data1 = torch.zeros(self.dataset.shape, dtype=torch.float, device=self.device)
        data2 = torch.zeros(self.dataset.shape, dtype=torch.float, device=self.device)
        data1[:, 0] = self.dataset[:, 0]
        data2[:, 1] = self.dataset[:, 1]
        #
        # break_limit = 3
        # break_flag = 0
        # score_flag = 0
        #
        for epoch in range(self.n_epoch):
            self.f.train()
            self.f.zero_grad()
            target1 = self.f(data1)
            target2 = data2
            score = cc_square(target1, target2)+0.0067  # set 0.0067 to make type I error almost = 0.05
            #
            # if score > score_flag:
            #     score_flag = score
            #     break_flag = 0
            # else:
            #     break_flag = break_flag + 1
            if score > 0.01: #or break_flag == break_limit:
            	break

            loss = -(score)
            loss.backward()    
            self.optim_f.step()
        return score.item() 

class Test(nn.Module):

    def __init__(self, input_size=5, num_layer=4, hidden_size=20):
        super().__init__()
        net = [
            snlinear(input_size, hidden_size, bias=False),
            nn.ReLU(True),
        ]
        for i in range(num_layer - 2):
            net.append(snlinear(hidden_size, hidden_size, bias=False))
            net.append(nn.ReLU(True))
        net.append(snlinear(hidden_size, 1, bias=False))
        self.net = nn.Sequential(*net)
        self.sample()

    def sample(self, ini_type='kaiming_unif'):
        if ini_type == 'kaiming_unif':
            self.apply(init_kaiming_unif)
        elif ini_type == 'kaiming_norm':
            self.apply(init_kaiming_norm)
        else: 
            self.apply(init_norm)

    def forward(self, x):
        return self.net(x)

def cc_square(x, y):
    cov = (x * y).mean() - x.mean() * y.mean()
    var_x = x.var(unbiased=False)
    var_y = y.var(unbiased=False)
    return cov**2 / (var_x * var_y)

def snlinear(in_features, out_features, bias=False): 
    return spectral_norm(nn.Linear(in_features=in_features, out_features=out_features, bias=bias))

def init_kaiming_unif(m):
    if type(m) == nn.Linear or type(m) == nn.Conv2d or type(m) == nn.ConvTranspose2d:
        init.kaiming_uniform_(m.weight)

def init_kaiming_norm(m):
    if type(m) == nn.Linear or type(m) == nn.Conv2d or type(m) == nn.ConvTranspose2d:
        init.kaiming_normal_(m.weight)

def init_norm(m):
    if type(m) == nn.Linear or type(m) == nn.Conv2d or type(m) == nn.ConvTranspose2d:
        init.normal_(m.weight, mean=0, std=1)

def main_darling(d1,d2): 

    data = np.zeros([2,len(d1)])
    data[0] = d1
    data[1] = d2
    test_data = data.transpose()
    bar = 0.01
    ind = True
    score = Darling(dataset=test_data)
    val = score.darling_test()
    if val > bar:
        ind = False 
    else:
        ind = True
    return ind